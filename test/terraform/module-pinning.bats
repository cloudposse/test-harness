load 'lib'

function setup() {
  if ! which terraform-config-inspect; then
    log "'terraform-config-inspect' must be installed in the test harness. Check https://github.com/hashicorp/terraform-config-inspect for instructions "
    false
  fi
  TMPFILE="$(mktemp /tmp/terraform-modules-XXXXXXXXXXX.txt)"
}

function teardown() {
  #rm -f $TMPFILE
:
}

@test "check if terraform modules are properly pinned" {
  skip_unless_terraform
  ## Extract all module calls (except submodules in ./modules/) into string with source then | then version (if version parameter exists)
  ## Add || true at the end because a pipe failure just means this module has no calls to other modules
  ## The  grep -v '^"\.\./' is to exclude modules in the same repo (e.g. "../stack") from the check
  terraform-config-inspect --json . | jq '.module_calls[] | "\(.source)|\(.version)"' | grep -v -F '"./modules' | grep -v '^"\.\./' > $TMPFILE || true
  ## check if module url have version in tags or if version pinned with 'version' parameter for Terraform Registry notation
  ## check diff between terraform-config-inspect output and regexp check to see if all cases are passing checks
  fail=$(grep -vE '^(\".*?tags\/[0-9]+\.[0-9]+.*\|null\"\s?|\".*?\|[0-9]+\.[0-9]+.*\"\s?)+' $TMPFILE) || true
  if [[ -n "$fail" ]]; then
    output_msg=$'\nCloud Posse requires all module sources to be pinned to a specific version, e.g. 0.9.1\n'
    output_msg+=$'Please fix these module sources:\n'
    nl=$'\n'
    output_msg+=$(printf "%s\n" "${fail[@]}" | sed -e 's/"/  - /' -e 's/|null//' | sed -E 's/^  - ([^|]+)\|(.*)$/  - source  = "\1"'"\\$nl"'    version = "\2"/g')
    log "$output_msg"
    return 1
  fi
  true
}

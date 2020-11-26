load 'lib'

function setup() {
  TMPFILE="$(mktemp /tmp/terraform-modules-XXXXXXXXXXX.txt)"
}

function teardown() {
  #rm -f $TMPFILE
:
}

@test "check if terraform modules are properly pinned" {
  skip_unless_terraform
  TCI_BINARY="$(go env GOPATH)/bin/terraform-config-inspect"
  if [[ ! -f $TCI_BINARY ]]; then
    log "Looking for 'terraform-config-inspect' in $TCI_BINARY"
    log "'terraform-config-inspect' go module required. Check https://github.com/hashicorp/terraform-config-inspect for instructions "
    false
  fi
  ## extract all module calls into string with source then | then version (if version parameter exists)
  $TCI_BINARY --json . | jq '.module_calls[] | "\(.source)|\(.version)"' > $TMPFILE
  ## check if module url have version in tags or if version pinned with 'version' parameter for Terraform Registry notation
  ## check diff between terraform-config-inspect output and regexp check to see if all cases are passing checks
  grep -Eo '^(\".*?tags\/[0-9]+\.[0-9]+.*\|null\"\s?|\".*?\|[0-9]+\.[0-9]+.*\"\s?)+' $TMPFILE | diff $TMPFILE -
}

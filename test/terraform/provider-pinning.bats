load 'lib'

function setup() {
  if ! which terraform-config-inspect; then
    log "'terraform-config-inspect' must be installed in the test harness. Check https://github.com/hashicorp/terraform-config-inspect for instructions "
    false
  fi
  export TF_CLI_ARGS_init="-get-plugins -backend=false -input=false"
  rm -rf .terraform
  TMPFILE="$(mktemp /tmp/terraform-providers-XXXXXXXXXXX.txt)"
}

function teardown() {
  rm -rf .terraform
  rm -f $TMPFILE
  unset TF_CLI_ARGS_init
}

@test "check if terraform providers are properly pinned" {
  skip_unless_terraform

  ## extract all required providers into string with 'provider' | then version constraint
  terraform-config-inspect --json . | jq '.required_providers | to_entries[] | "  - \(.key)|\(.value.version_constraints[])"' > $TMPFILE
  ## check if provider version constraint doesn't use pessimistic constraint operator '~>'
  ## then check diff between terraform-config-inspect output and regexp check to see if all cases are passing checks
  fail=$(grep -E '[~<]' $TMPFILE) || true
  if [[ -n "$fail" ]]; then
    printf '\n* Cloud Posse requires all providers to be pinned with ">=" constraints and only ">=" constraints\n'
    printf '* Please fix these constraints:\n'
    printf "%s\n" "${fail[@]}" | sed 's/|/  = /g' | sed 's/"//g'
    printf "\n\n"
    exit 1
  fi
  true
}

@test "check if terraform providers have explicit source locations for TF =>0.13" {
  skip_unless_terraform

  if vert "$(terraform-config-inspect --json . | jq -r '.required_core[]')" 0.12.25 >/devnull; then
    # Terraform version '$TERRAFORM_CORE_VERSION' less then 13. Skipping check for explicit provider source locations
    # ref: https://www.terraform.io/upgrade-guides/0-13.html#explicit-provider-source-locations
    skip "Minimum Terraform version less then 0.12.26. Skipping check for explicit provider source locations"
  else
    ## extract all required providers with sources into string with 'provider' | then 'source'
    terraform-config-inspect --json . | jq '.required_providers | to_entries[] | "  - \(.key)|\(.value.source)"' > $TMPFILE
    ## check if provider source exists for every provider
    fail=$(grep -F '|null' $TMPFILE) || true
    if [[ -n "$fail" ]]; then
      printf '\n* Cloud Posse requires all providers to use registry format introduced in Terraform 0.13, for example\n'
      printf '    aws = {\n       source  = "hashicorp/aws"\n       version = ">= 3.0"\n    }\n\n'
      printf '* Please add constraints for these providers:\n'
      printf "%s\n" "${fail[@]}" | cut '-d|' -f 1 | sed 's/"//g'
      printf "\n\n"
      exit 1
    fi
    true
  fi
}

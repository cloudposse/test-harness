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

  # check if all required_providers have version_constraints
  no_version_provider=$(terraform-config-inspect --json . | jq '.required_providers[] | select (.version_constraints == null)[]')
  if [[ -n "$no_version_provider" ]]; then
    fail_msg=$'Providers without version constraint found:\n'
    log "${fail_msg}${no_version_provider}"
    return 1
  fi

  ## extract all required providers into string with 'provider' | then version constraint
  terraform-config-inspect --json . | jq '.required_providers | to_entries[] | "  - \(.key)|\(.value.version_constraints[])"' > $TMPFILE
  ## Ensure provider version constraint is '>='
  fail=$(grep -v '|>=' $TMPFILE) || true
  if [[ -n "$fail" ]]; then
    output_msg=$'\nCloud Posse requires all providers to be pinned with ">=" constraints and only ">=" constraints\n'
    output_msg+=$'Please fix these constraints:\n'
    output_msg+=$(printf "%s\n" "${fail[@]}" | sed 's/|/: /g' | sed 's/"//g')
    log "$output_msg"
  fi
  [[ -z "$fail" ]]
}

@test "check if terraform providers have explicit source locations for TF =>0.13" {
  skip_unless_terraform

  if vert "$(terraform-config-inspect --json . | jq -r '.required_core[]')" 0.12.25 >/devnull; then
    # Terraform version '$TERRAFORM_CORE_VERSION' less then 13. Skipping check for explicit provider source locations
    # ref: https://www.terraform.io/upgrade-guides/0-13.html#explicit-provider-source-locations
    skip "Minimum Terraform version less than 0.12.26. Skipping check for explicit provider source locations"
  else
    ## extract all required providers with sources into string with 'provider' | then 'source'
    terraform-config-inspect --json . | jq '.required_providers | to_entries[] | "  - \(.key)|\(.value.source)"' > $TMPFILE
    ## check if provider source exists for every provider
    fail=$(grep -F '|null' $TMPFILE) || true
    if [[ -n "$fail" ]]; then
      output_msg=$'\nCloud Posse requires all providers to use registry format introduced in Terraform 0.13, for example\n'
      output_msg+=$'    aws = {\n       source  = "hashicorp/aws"\n       version = ">= 3.0"\n    }\n\n'
      output_msg+=$'Please add constraints for these providers:\n'
      output_msg+=$(printf "%s\n" "${fail[@]}" | cut '-d|' -f 1 | sed 's/"//g')
      log "$output_msg"
      return 1
    fi
    true
  fi
}

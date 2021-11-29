load 'lib'

function setup() {
  skip_unless_terraform
  clean
  export TF_CLI_ARGS_init="-input=false -backend=false"
  terraform init >/dev/null
}

function teardown() {
  clean
  unset TF_CLI_ARGS_init
  unset AWS_DEFAULT_REGION
}

@test "check if terraform code is valid" {
  skip_unless_terraform
  if [[ "`terraform version | head -1`" =~ 0\.11 ]]; then
    run terraform validate -check-variables=false
    [ $status -eq 0 ]
    [ -z "$output" ]
  else if [[ ! vert "$(terraform-config-inspect --json . | jq -r '.required_core[]')" 0.14.0 ]]; then
    export AWS_DEFAULT_REGION="us-east-2"
    export TEST_HARNESS_VALIDATE_DIR=examples/complete
    if [[ -d $TEST_HARNESS_VALIDATE_DIR ]]; then
      run terraform validate -chdir=$TEST_HARNESS_VALIDATE_DIR .
    else
      run terraform validate .
    fi
    log_on_error "$status" "$output"
  else
    export AWS_DEFAULT_REGION="us-east-2"
    run terraform validate .
    log_on_error "$status" "$output"
  fi
}

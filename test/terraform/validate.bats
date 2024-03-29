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
  if [[ "`terraform version | head -1`" =~ ^0\.11 ]]; then
    run terraform validate -check-variables=false
    log_on_error "$status" "$output"
    [ -z "$output" ] || log_on_error "99" "$output"
  else
    export AWS_DEFAULT_REGION="us-east-2"
    run terraform validate .
    log_on_error "$status" "$output"
  fi
}

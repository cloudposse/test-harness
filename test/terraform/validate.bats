load 'lib'

function setup() {
  skip_unless_terraform
  clean
  export TF_CLI_ARGS_init="-input=false -backend=false"
  terraform init
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
  else
    export AWS_DEFAULT_REGION="us-east-2"
    run terraform validate .
    [ $status -eq 0 ]
  fi
}

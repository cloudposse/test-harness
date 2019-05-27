load 'lib'

function setup() {
  skip_unless_terraform
  clean
  export TF_CLI_ARGS_apply="-auto-approve -input=false"
  export TF_CLI_ARGS_destroy="-auto-approve"
  terraform init
}

function teardown() {
  terraform destroy
  clean
}

@test "check if terraform apply works" {
  skip_unless_terraform
  run terraform apply
  log "$output"
  [ $status -eq 0 ]
}

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
  unset TF_CLI_ARGS_apply
  unset TF_CLI_ARGS_destroy
}

@test "check if terraform apply works" {
  skip_unless_terraform
  run terraform apply
  if [ $status -ne 0 ]; then
    log "$output"
    return 1
  else
    output_only "$output"
  fi
}

load 'lib'

function setup() {
  skip_unless_terraform
  export TF_CLI_ARGS_plan="-input=false -detailed-exitcode"
  export TF_CLI_ARGS_apply="-auto-approve -input=false"
  export TF_CLI_ARGS_destroy="-auto-approve"
  terraform init
}

function teardown() {
  skip_unless_terraform
  clean
}

@test "check if terraform is idempotent" {
  # https://www.terraform.io/docs/commands/plan.html#usage

  # Run `terraform plan` (expect changes?)
  run terraform plan
  log "$output"
  [ $status -eq 2 ]

  # Run `terraform apply`
  run terraform apply
  log "$output"
  [ $status -eq 0 ]

  # Run `terraform plan` (expect no changes)
  run terraform plan
  log "$output"
  [ $status -eq 0 ]

  # Run `terraform destroy`
  run terraform destroy -auto-approve 
  log "$output"
  [ $status -eq 0 ]

  # Run `terraform plan` (expect changes?)
  run terraform plan -input=false -detailed-exitcode -no-color
  log "$output"
  [ $status -eq 2 ]

}

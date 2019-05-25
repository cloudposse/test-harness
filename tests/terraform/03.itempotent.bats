load 'lib'

function setup() {
  skip_unless_terraform
  terraform init
}

function teardown() {
  skip_unless_terraform
  clean
}

@test "check if terraform is idempotent" {
  # https://www.terraform.io/docs/commands/plan.html#usage

  # Run `terraform plan` (expect changes?)
  run terraform plan -input=false -detailed-exitcode -no-color
  log "$output"
  [ $status -eq 2 ]

  # Run `terraform apply`
  run terraform apply -no-color -input=false -auto-approve 
  log "$output"
  [ $status -eq 0 ]

  # Run `terraform plan` (expect no changes)
  run terraform plan -input=false -detailed-exitcode -no-color
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

load 'lib'

function setup() {
  skip_unless_terraform
  clean
  init-terraform
}

function teardown() {
  clean
}

@test "check if terraform apply works" {
  skip_unless_terraform
  run terraform apply -input=false -auto-approve -detailed-exitcode -no-color
  log "$output"
  [ $status -eq 0 ]
}

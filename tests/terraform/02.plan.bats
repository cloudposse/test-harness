load 'lib'

function setup() {
  skip_unless_terraform
  clean
  terraform init
}

function teardown() {
  clean
}

@test "check if terraform plan works" {
  skip_unless_terraform
  run terraform plan -input=false -detailed-exitcode -no-color
  log "$output"
  [ $status -eq 0 ]
}

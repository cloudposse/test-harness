load 'lib'

function setup() {
#  skip_unless_terraform
#  init-terraform
:
}

function teardown() {
#  skip_unless_terraform
  clean
}

@test "check if terraform plan works" {
  skip_unless_terraform
  run make -s plan
  log "$output"
  [ $status -eq 0 ]
}

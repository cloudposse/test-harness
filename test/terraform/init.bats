load 'lib'

function setup() {
  clean
}

function teardown() {
  clean
}

@test "check if terraform init succeeds" {
  skip_unless_terraform
  run terraform init -input=false
  log "$output"
  [ $status -eq 0 ]
}

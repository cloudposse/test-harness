load 'lib'

function setup() {
  rm -rf .terraform
}

function teardown() {
  rm -rf .terraform
}

@test "check if terraform init works" {
  skip_unless_terraform
  run make -s init
  log "$output"
  [ $status -eq 0 ]
}

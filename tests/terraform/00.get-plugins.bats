load 'lib'

function setup() {
  clean
}

function teardown() {
  clean
}

@test "check if terraform plugins are valid" {
  skip_unless_terraform
  run bash -c "terraform init -get-plugins -backend=false -input=false"
}

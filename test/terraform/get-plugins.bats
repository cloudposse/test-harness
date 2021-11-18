load 'lib'

function setup() {
  clean
}

function teardown() {
  clean
}

@test "check if terraform plugins are valid" {
  skip_unless_terraform
  skip "Terraform no longer supports separate testing of plugins"
}

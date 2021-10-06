load 'lib'

function setup() {
  clean
}

function teardown() {
  clean
}

@test "check if terraform modules are valid" {
  skip_unless_terraform
  skip "Terraform no longer supports separate testing of module loading"
}

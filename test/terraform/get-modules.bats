load 'lib'

function setup() {
  exprt TF_CLI_ARGS_init="-get-plugins -backend=false -input=false"
  clean
}

function teardown() {
  clean
  unset TF_CLI_ARGS_init
}

@test "check if terraform modules are valid" {
  skip_unless_terraform
  terraform init
}

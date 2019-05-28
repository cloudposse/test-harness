load 'lib'

function setup() {
  export TF_CLI_ARGS_init="-get-plugins -backend=false -input=false"
  clean
}

function teardown() {
  clean
  unset TF_CLI_ARGS_init
}

@test "check if terraform plugins are valid" {
  skip_unless_terraform
  terraform init
}

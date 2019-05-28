load 'lib'

function setup() {
  export TF_CLI_ARGS_init="-get-plugins -backend=false -input=false"
  rm -rf .terraform
}

function teardown() {
  rm -rf .terraform
  unset TF_CLI_ARGS_init
}

@test "check if terraform providers are properly pinned" {
  skip_unless_terraform
  run bash -c "terraform init 2>&1 | grep 'provider.*version = .*'"
  log "$output"
  [ $status -ne 0 ]
}

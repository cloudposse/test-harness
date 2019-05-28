load 'lib'

function setup() {
  rm -rf .terraform
}

function teardown() {
  rm -rf .terraform
}

@test "check if terraform providers are properly pinned" {
  skip_unless_terraform
  run bash -c "terraform init 2>&1 | grep 'provider.*version = .*'"
  log "$output"
  [ $status -ne 0 ]
}

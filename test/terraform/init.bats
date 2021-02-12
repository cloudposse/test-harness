load 'lib'

function setup() {
  rm -rf .terraform
}

function teardown() {
  rm -rf .terraform
}

@test "check if terraform init works" {
  skip_unless_terraform
  run terraform init
  if [ $status -ne 0 ]; then
    log "$output"
    return 1
  else
    output_only "$output"
  fi
}

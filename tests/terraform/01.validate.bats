load 'lib'

@test "check if terraform code is valid" {
  skip_unless_terraform
  run bash -c "terraform validate -check-variables=false"
  log "$output"
  [ $status -eq 0 ]
  [ -z "$output" ]
}

load 'lib'

@test "check if terraform code needs formatting" {
  skip_if_disabled
  skip_unless_terraform
  run bash -c "terraform fmt -write=false"
  log "$output"
  [ $status -eq 0 ]
  [ -z "$output" ]
}

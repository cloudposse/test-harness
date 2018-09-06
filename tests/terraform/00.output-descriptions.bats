load 'lib'

@test "check if terraform outputs have descriptions" {
  skip_unless_terraform
  run bash -c "terraform-docs json . | jq -rS '.Outputs[] | select (.Description == \"\") | .Name'"
  log "$output"
  [ -z "$output" ]
}

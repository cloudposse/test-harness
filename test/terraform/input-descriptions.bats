load 'lib'

@test "check if terraform inputs have descriptions" {
  skip_unless_terraform
  run bash -c "terraform-docs json . | jq -rS '.Inputs[] | select (.Description == \"\") | .Name'"
  log "$output"
  [ -z "$output" ]
}

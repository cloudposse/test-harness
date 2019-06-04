load 'lib'

@test "check if terraform inputs have descriptions" {
  TMPFILE="$(mktemp /tmp/terraform-docs-XXXXXXXXXXX.json)"
  skip_unless_terraform
  terraform_docs json . > $TMPFILE
  run bash -c "jq -rS '.Inputs[] | select (.Description == \"\") | .Name' < $TMPFILE"
  rm -f $TMPFILE
  log "$output"
  [ -z "$output" ]
}

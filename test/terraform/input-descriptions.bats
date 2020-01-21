load 'lib'

function setup() {
  TMPFILE="$(mktemp /tmp/terraform-docs-XXXXXXXXXXX.json)"
}

function teardown() {
  rm -f $TMPFILE
}

@test "check if terraform inputs have descriptions" {
  skip_unless_terraform
  terraform_docs json . > $TMPFILE
  run bash -c "jq -rS '.inputs[] | select (.Description == \"\") | .Name + \" is missing a description\"' < $TMPFILE"
  log "$output"
  [ -z "$output" ]
}

load 'lib'

function setup() {
  TMPFILE="$(mktemp /tmp/terraform-docs-XXXXXXXXXXX.json)"
}

function teardown() {
  rm -f $TMPFILE
}

@test "check if terraform outputs have descriptions" {
  skip_unless_terraform
  terraform-docs json . > $TMPFILE
  run bash -c "jq -rS '.outputs[] | select (.description == \"\" or .description == null) | .name + \" is missing a description\"' < $TMPFILE"
  log "$output"
  [ -z "$output" ]
}

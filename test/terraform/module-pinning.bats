load 'lib'

function setup() {
:
}

function teardown() {
:
}

@test "check if terraform modules are properly pinned" {
  skip_unless_terraform
  TMPFILE="$(mktemp /tmp/terraform-modules-XXXXXXXXXXX.json)"
  grep -Eo '^\s*source\s*=\s*"(.*?)"' *.tf | cut -d'"' -f2 | sort -u | sed 's/^.*?ref=//' > $TMPFILE
  run bash -c "grep -Ev '^(tags/[0-9]+\\.[0-9]+.*|)$$' $TMPFILE"
  log "$output"
  rm -f $TMPFILE
  [ $status -eq 0 ]
}

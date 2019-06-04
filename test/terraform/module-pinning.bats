load 'lib'

function setup() {
  TMPFILE="$(mktemp /tmp/terraform-modules-XXXXXXXXXXX.txt)"
}

function teardown() {
  #rm -f $TMPFILE
:
}

@test "check if terraform modules are properly pinned" {
  skip_unless_terraform
  grep -Eo '^\s*source\s*=\s*"(.*?)"' *.tf | cut -d'"' -f2 | sort -u | sed 's/^.*?ref=//' > $TMPFILE
  grep -E '^(tags/[0-9]+\.[0-9]+.*|)$' $TMPFILE
}

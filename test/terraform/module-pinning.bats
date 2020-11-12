load 'lib'

function setup() {
  TMPFILE="$(mktemp /tmp/terraform-modules-XXXXXXXXXXX.txt)"
}

function teardown() {
  #rm -f $TMPFILE
:
}

@test "check if terraform modules are properly pinned" {
  skip_if_disabled
  skip_unless_terraform
  grep -Eo '^\s*source\s*=\s*"(.*?)"' *.tf | cut -d'"' -f2 | sort -u > $TMPFILE
  if [ -s $TMPFILE ]; then
    # Verify the modules are pinned to `tags/x.y` or nothing at all (maybe using `version` parameter instead)
    sed 's/^.*?ref=//' < $TMPFILE | grep -E '^(tags/[0-9]+\.[0-9]+.*|)$'
  else
    # If the file is empty, then no modules are being used
    true
  fi
}

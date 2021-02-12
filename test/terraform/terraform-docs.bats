load 'lib'

@test "check if terraform-docs is installed" {
  skip_unless_terraform
  run which terraform-docs
  if [ $status -ne 0 ]; then
    log "'which terraform-docs' failed"
    return 1
  fi
}

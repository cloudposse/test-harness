load 'lib'

@test "check if terraform is installed" {
  skip_unless_terraform
  run which terraform
  if [ $status -ne 0 ]; then
    log "'which terraform' failed"
    return 1
  fi
}

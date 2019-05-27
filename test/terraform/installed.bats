load 'lib'

@test "check if terraform is installed" {
  skip_unless_terraform
  which terraform
}

load 'lib'

@test "check if terraform-docs is installed" {
  skip_unless_terraform
  which terraform-docs
}

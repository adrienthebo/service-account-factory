PROJECT_ROOT="$(git rev-parse --show-toplevel)"
EXAMPLE_DIR="${PROJECT_ROOT}/examples/group_management"

teardown() {
  cd "$EXAMPLE_DIR" && rm -rf .terraform
}

@test "Terraform can initialize and generate a plan for 'examples/group_management'" {
  cd "$EXAMPLE_DIR"
  terraform init
  terraform get
  terraform plan -input=false
}

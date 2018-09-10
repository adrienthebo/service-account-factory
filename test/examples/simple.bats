PROJECT_ROOT="$(git rev-parse --show-toplevel)"
EXAMPLE_DIR="${PROJECT_ROOT}/examples/simple"

teardown() {
  cd "$EXAMPLE_DIR" && rm -rf .terraform
}

@test "Terraform can initialize and generate a plan for 'examples/simple'" {
  cd "$EXAMPLE_DIR"
  terraform init
  terraform get
  terraform plan -input=false
}

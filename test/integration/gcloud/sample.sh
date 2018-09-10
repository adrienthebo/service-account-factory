# Export configuration for terraform and inspec

# Terraform variables definitions
TF_VAR_project_id="SET ME"
TF_VAR_credentials_path="SET ME"

# Inspec/GCP configuration
GOOGLE_APPLICATION_CREDENTIALS="$TF_VAR_credentials_path"

export TF_VAR_project_id TF_VAR_credentials_path GOOGLE_APPLICATION_CREDENTIALS

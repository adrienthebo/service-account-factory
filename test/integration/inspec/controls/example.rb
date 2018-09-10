# encoding: utf-8

describe google_service_account(
    name: "projects/#{ENV['TF_VAR_project_id']}/serviceAccounts/editor-service-account@#{ENV['TF_VAR_project_id']}.iam.gserviceaccount.com"
) do
  its('display_name') { should eq 'Service account with editor rights' }
  its('project_id') { should eq ENV['TF_VAR_project_id'] }
end

describe google_service_account(
    name: "projects/#{ENV['TF_VAR_project_id']}/serviceAccounts/browser-service-account@#{ENV['TF_VAR_project_id']}.iam.gserviceaccount.com"
) do
  its('display_name') { should eq 'Service account with browser rights' }
  its('project_id') { should eq ENV['TF_VAR_project_id'] }
end

describe google_service_account(
    name: "projects/#{ENV['TF_VAR_project_id']}/serviceAccounts/limited-service-account@#{ENV['TF_VAR_project_id']}.iam.gserviceaccount.com"
) do
  its('display_name') { should eq 'Service account with no special rights' }
  its('project_id') { should eq ENV['TF_VAR_project_id'] }
end

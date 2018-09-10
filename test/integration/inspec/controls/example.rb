# encoding: utf-8

describe google_service_account(
    name: "projects/#{ENV['TF_VAR_project_id']}/serviceAccounts/editor-service-account@#{ENV['TF_VAR_project_id']}.iam.gserviceaccount.com"
) do
  its('display_name') { should eq 'Service account with editor rights' }
  its('project_id') { should eq ENV['TF_VAR_project_id'] }
end

describe google_project_iam_binding(
    project: ENV['TF_VAR_project_id'],
    role: 'roles/editor') do
  it { should exist }

  its('members') { should include "serviceAccount:editor-service-account@#{ENV['TF_VAR_project_id']}.iam.gserviceaccount.com" }
  its('members') { should_not include "serviceAccount:browser-service-account@#{ENV['TF_VAR_project_id']}.iam.gserviceaccount.com" }
  its('members') { should_not include "serviceAccount:limited-service-account@#{ENV['TF_VAR_project_id']}.iam.gserviceaccount.com" }
end

describe google_service_account(
    name: "projects/#{ENV['TF_VAR_project_id']}/serviceAccounts/browser-service-account@#{ENV['TF_VAR_project_id']}.iam.gserviceaccount.com"
) do
  its('display_name') { should eq 'Service account with browser rights' }
  its('project_id') { should eq ENV['TF_VAR_project_id'] }
end

describe google_project_iam_binding(
    project: ENV['TF_VAR_project_id'],
    role: 'roles/browser') do
  it { should exist }

  its('members') { should_not include "serviceAccount:editor-service-account@#{ENV['TF_VAR_project_id']}.iam.gserviceaccount.com" }
  its('members') { should include "serviceAccount:browser-service-account@#{ENV['TF_VAR_project_id']}.iam.gserviceaccount.com" }
  its('members') { should_not include "serviceAccount:limited-service-account@#{ENV['TF_VAR_project_id']}.iam.gserviceaccount.com" }
end

describe google_service_account(
    name: "projects/#{ENV['TF_VAR_project_id']}/serviceAccounts/limited-service-account@#{ENV['TF_VAR_project_id']}.iam.gserviceaccount.com"
) do
  its('display_name') { should eq 'Service account with no special rights' }
  its('project_id') { should eq ENV['TF_VAR_project_id'] }
end

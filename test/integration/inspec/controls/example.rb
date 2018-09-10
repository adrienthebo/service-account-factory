# encoding: utf-8

describe google_service_account(
    name: "projects/#{ENV['PROJECT_ID']}/serviceAccounts/editor-service-account@#{ENV['PROJECT_ID']}.iam.gserviceaccount.com"
) do
  its('display_name') { should eq 'Service account with editor rights' }
  its('project_id') { should eq ENV['PROJECT_ID'] }
end

describe google_project_iam_binding(
    project: ENV['PROJECT_ID'],
    role: 'roles/editor') do
  it { should exist }

  its('members') { should include "serviceAccount:editor-service-account@#{ENV['PROJECT_ID']}.iam.gserviceaccount.com" }
  its('members') { should_not include "serviceAccount:browser-service-account@#{ENV['PROJECT_ID']}.iam.gserviceaccount.com" }
  its('members') { should_not include "serviceAccount:limited-service-account@#{ENV['PROJECT_ID']}.iam.gserviceaccount.com" }
end

describe google_service_account(
    name: "projects/#{ENV['PROJECT_ID']}/serviceAccounts/browser-service-account@#{ENV['PROJECT_ID']}.iam.gserviceaccount.com"
) do
  its('display_name') { should eq 'Service account with browser rights' }
  its('project_id') { should eq ENV['PROJECT_ID'] }
end

describe google_project_iam_binding(
    project: ENV['PROJECT_ID'],
    role: 'roles/browser') do
  it { should exist }

  its('members') { should_not include "serviceAccount:editor-service-account@#{ENV['PROJECT_ID']}.iam.gserviceaccount.com" }
  its('members') { should include "serviceAccount:browser-service-account@#{ENV['PROJECT_ID']}.iam.gserviceaccount.com" }
  its('members') { should_not include "serviceAccount:limited-service-account@#{ENV['PROJECT_ID']}.iam.gserviceaccount.com" }
end

describe google_service_account(
    name: "projects/#{ENV['PROJECT_ID']}/serviceAccounts/limited-service-account@#{ENV['PROJECT_ID']}.iam.gserviceaccount.com"
) do
  its('display_name') { should eq 'Service account with no special rights' }
  its('project_id') { should eq ENV['PROJECT_ID'] }
end

ENV.fetch('SHARED_VPC_SUBNETS', '').split(':').each do |subnet|
  describe google_subnet_iam_binding(subnet: subnet, role: 'roles/compute.networkUser') do
    it { should exist }

    its('members') { should include "serviceAccount:editor-service-account@#{ENV['PROJECT_ID']}.iam.gserviceaccount.com" }
    its('members') { should_not include "serviceAccount:browser-service-account@#{ENV['PROJECT_ID']}.iam.gserviceaccount.com" }
    its('members') { should_not include "serviceAccount:limited-service-account@#{ENV['PROJECT_ID']}.iam.gserviceaccount.com" }
  end
end

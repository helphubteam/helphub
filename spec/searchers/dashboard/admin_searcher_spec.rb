require 'rails_helper'

describe Dashboard::AdminSearcher do
  let(:user) { create :user, :admin }
  subject(:data) { described_class.new(user).call }

  let(:expected_result) do
    {
      full: {
        help_requests_count: 22,
        moderators_count: 2,
        organizations_count: 1,
        volunteers_count: 3
      },
      week: {
        help_requests_count: 15,
        help_requests_submissions: 5,
        volunteers_count: 2
      }
    }
  end

  before(:each) do
    past_time = 3.weeks.ago

    test_organization = create :organization, test: true
    test_volunteer = create :user, :volunteer, organization: test_organization
    test_moderator = create :user, :moderator, organization: test_organization

    archive_organization = create :organization, archive: true
    archive_volunteer = create :user, :volunteer, organization: archive_organization
    archive_moderator = create :user, :moderator, organization: archive_organization

    organization = create :organization
    moderator1 = create :user, :moderator, organization: organization
    moderator2 = create :user, :moderator, organization: organization
    volunteer1 = create :user, :volunteer, organization: organization
    create :user, :volunteer, organization: organization
    volunteer2 = create :user, :volunteer, organization: organization, created_at: past_time

    15.times do |i|
      hr = create :help_request, organization: organization, creator: moderator1
      create :help_request_log, help_request: hr, kind: 'assigned', user: user
      create :help_request_log, help_request: hr, kind: 'submitted', user: volunteer2 if i > 9
    end

    7.times do
      hr = create :help_request, organization: organization, created_at: past_time, creator: moderator2
      create :help_request_log, help_request: hr, kind: 'assigned', user: volunteer1, created_at: past_time
      create :help_request_log, help_request: hr, kind: 'submitted', user: volunteer1, created_at: past_time
    end

    3.times do
      hr = create :help_request, organization: test_organization, creator: moderator1
      create :help_request_log, help_request: hr, kind: 'assigned', user: test_volunteer
      create :help_request_log, help_request: hr, kind: 'submitted', user: test_volunteer
    end

    2.times do
      hr = create :help_request, organization: archive_organization, creator: moderator2
      create :help_request_log, help_request: hr, kind: 'assigned', user: archive_volunteer
      create :help_request_log, help_request: hr, kind: 'submitted', user: archive_volunteer
    end
  end

  it 'responds correct statistic' do
    is_expected.to eq(expected_result)
  end
end

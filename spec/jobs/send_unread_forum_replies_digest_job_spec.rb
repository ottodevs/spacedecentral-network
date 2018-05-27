require 'rails_helper'

RSpec.describe SendUnreadForumRepliesDigestJob, type: :job do
  let(:users) { create_list(:random_user, 5) }

  it "sends digest emails to all users" do
    SendUnreadForumRepliesDigestJob.perform_now(users)
    expect(jobs_count).to eq 5
  end
end

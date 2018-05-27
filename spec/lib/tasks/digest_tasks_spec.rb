require 'rails_helper'

describe 'digests:unread_forum_replies' do
  before do
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
  end

  it "schedules background job to perform soon" do
    subject.execute
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq 1
  end
end

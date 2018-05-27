require "rails_helper"

describe UnreadForumRepliesMailer, type: :mailer do
  let(:user) { create(:random_user) }
  let(:mail) { UnreadForumRepliesMailer.send_digest(user) }

  it 'renders the subject' do
    expect(mail.subject).to eql("Hello, #{user.name}, you have new replies")
  end
end

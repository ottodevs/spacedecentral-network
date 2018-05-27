class SendUnreadForumRepliesDigestJob < ApplicationJob
  queue_as :default

  def perform(users)
    users.each do |user|
      UnreadForumRepliesMailer.send_digest(user).deliver_later
    end
  end
end

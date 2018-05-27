namespace :digests do
  desc "Send daily digest with unread forum replies"
  task unread_forum_replies: :environment do
    SendUnreadForumRepliesDigestJob.perform_later
  end

end

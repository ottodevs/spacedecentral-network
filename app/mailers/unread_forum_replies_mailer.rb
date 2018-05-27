class UnreadForumRepliesMailer < ApplicationMailer
  default from: 'info@spacedecentral.net'

  def send_digest(user)
    @user = user

    mail( to: @user.email, subject: "Hello, #{@user.name}, you have new replies", template_path: 'mailers/digests', template_name: 'unread_forum_replies')
  end
end

module Mailer
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def reset_emails
    ActionMailer::Base.deliveries.clear
  end

  def deliveries_count
    ActionMailer::Base.deliveries.count
  end

  def extract_confirmation_token(email)
    email && email.body && email.body.match(/confirmation_token=(.+)">/x)[1]
  end

end

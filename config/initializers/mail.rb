ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :tls => true,
  :address => 'mail.lionsher.com',
  :port => 25,
  :domain => 'www.lionsher.com',
  :authentication => :plain,
  :user_name => 'team@lionsher.com',
  :password => 'teamlionsher123'

}

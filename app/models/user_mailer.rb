class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{SITE_URL}/"
  end
  
  def reset_notification(user)
    setup_email(user)
    @subject    += 'Link to reset your password'
    @body[:url]  = "http://#{SITE_URL}/reset/#{user.reset_code}"
  end
  
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "team@lionsher.com"
    @subject     = "[#{SITE_URL}] "
    @sent_on     = Time.now
    @body[:user] = user
  end

  #sending a new mail when a new is assigned to a person....

  def send_new_issue(issue,user)
    setup_email(user)
    @issue = issue
    @user = user
    @subject += "BUGZ: A new issue has been assigned to you"
    @from = "team@lionsher.com"
#    @body[:url] = "http://bugz.kernlearning.com/issues/show/#{@issue.id}"  # on staging
    @body[:url] = "http://localhost:3000/issues/show/#{@issue.id}"
    content_type "text/html"
  end

  #sending mail when new comment is added

  def send_new_comment(post,user,issue)
    setup_email(user)
    @post = post
    @user = user
    @issue = issue
    @subject += "BUGZ: A new comment has been posted"
    @from = "team@lionsher.com"
#    @body[:url] = "http://bugz.kernlearning.com/issues/show/#{@issue.id}"  # on staging
    @body[:url] = "http://localhost:3000/issues/show/#{@issue.id}"
    content_type "text/html"
  end

  #sending the mail to the assigned to for the status update of the comment
  def send_comment_to_assigned_to_for_status(post,user,issue)
    setup_email(user)
    @post = post
    @user = user
    @issue = issue
    @subject += "BUGZ: Issue status has been updated"
    @from = "team@lionsher.com"
#    @body[:url] = "http://bugz.kernlearning.com/issues/show/#{@issue.id}"  # on staging
    @body[:url] = "http://localhost:3000/issues/show/#{@issue.id}"
    content_type "text/html"
  end

end

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

  def send_new_issue(issue,user)
    setup_email(user)
    @issue = issue
    @user = user
    @subject    += @issue.short_description
    @from = "team@lionsher.com"
    @body[:url] = "http://192.168.1.29:3000/issues/show/#{@issue.id}"
    content_type "text/html"
  end


def send_new_comment(posts,user,issue)
    setup_email(user)
    @post = posts
    @user = user
    @issue = issue
    @from = "team@lionsher.com"
    @body[:url] = "http://192.168.1.29:3000/issues/show/#{@issue.id}"
    content_type "text/html"
  end

  def send_new_comment_to_assigned_to(posts,user,issue)
     setup_email(user)
    @post = posts
    @user = user
    @issue = issue
    @from = "team@lionsher.com"
    @body[:url] = "http://192.168.1.29:3000/issues/show/#{@issue.id}"
    content_type "text/html"
  end
end

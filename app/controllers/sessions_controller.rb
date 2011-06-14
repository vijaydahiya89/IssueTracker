# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  # render new.rhtml
  def new

  end

  def create
    @user = User.find_by_email(params[:login])
    unless @user.nil?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end      
      redirect_back_or_default('/issues/my_issues/'+current_user.id.to_s)
    else
      render :action => 'new'
    end
    else
      flash[:notice] = "Invalid login or password !"
      redirect_back_or_default('/')
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    redirect_back_or_default('/')
  end
end

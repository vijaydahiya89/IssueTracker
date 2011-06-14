class UsersController < ApplicationController

  # render new.rhtml
  def new
 
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.find_by_email(params[:user][:email])
    if !@user.nil?
      flash[:notice] = "User already exists."
      redirect_to('/users/new')
    elsif !params[:user][:login].empty? and !params[:user][:email].empty? and !params[:user][:password].empty? and !params[:user][:password_confirmation].empty?
      @user = User.new(params[:user])
      @user.save
      @issues = Issue.all
      @issues.each do |issue|
        @visit = Visit.new
        @visit.user_id = @user.id
        @visit.issue_id = issue.id
        @visit.visited_at = "2011-06-02 02:28:31"
        @visit.save
      end
      if @user.errors.empty?
        redirect_back_or_default('/')
        flash[:notice] = "Thanks for signing up! Please check your email to activate your account."
      else
        flash[:notice] = "Invalid details."
        redirect_to('/users/new')
      end
    else
      flash[:notice] = "Mandatory fields missing"
      redirect_to('/users/new')
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/issues/my_issues/'+current_user.id.to_s)
  end

  def forgot

  end

  def forgot_password
    if request.post?
      user = User.find_by_email(params[:user][:email])
      respond_to do |format|
        if user
          user.create_reset_code
          flash[:notice] = "Reset code sent to #{user.email}"
          
          format.html { redirect_to login_path }
          format.xml { render :xml => user.email, :status => :created }
        else
          flash[:error] = "#{params[:user][:email]} does not exist in system"
          format.html { redirect_to('/forgot') }
          flash[:notice] = "Enter correct Mail"
          format.xml { render :xml => user.email, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  def reset
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    if request.post?
      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        self.current_user = @user
        @user.delete_reset_code
        flash[:notice] = "Password reset successfully for #{@user.email}"
        redirect_to root_url
      else
        render :action => :reset
      end
    end
  end
  
end

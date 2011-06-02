class IssuesController < ApplicationController
  before_filter :login_required

  def index
    @open_bugs = Issue.find_all_by_issue_type_and_status("Bug","open",:order => "id DESC")
    @closed_bugs = Issue.find_all_by_issue_type_and_status("Bug","closed",:order => "id DESC")
    @open_features = Issue.find_all_by_issue_type_and_status("Feature","open",:order => "id DESC")
    @closed_features = Issue.find_all_by_issue_type_and_status("Feature","closed",:order => "id DESC")
  end

  def show
    @issue = Issue.find(params[:id])
    @user = User.find_by_id(@issue.assigned_to)
    @posts = Post.find_all_by_issue_id(params[:id],:order => "created_at DESC")
  end

  def new
    @issue = Issue.new
  end

  def edit
    @issue = Issue.find(params[:id])
  end

  def create
    @issue = current_user.issues.create(params[:issue])
    @issue.status = "open"
    @issue.save
    flash[:notice] = "Issue Added"
    redirect_to("/issues")
  end

  def update
    @issue = Issue.find(params[:id])
    @issue.update_attributes(params[:issue])
    redirect_to("/issues")
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    redirect_to("/issues/my_issues/"+current_user.id.to_s)
  end

  def my_issues
    @open_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","open",:order => "id DESC")
    @closed_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","closed",:order => "id DESC")
    @open_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","open",:order => "id DESC")
    @closed_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","closed",:order => "id DESC")
  end

  def user_issues
    @users = User.all(:order => 'login')
  end

  def close_issue
    @issue = Issue.find_by_id(params[:id])
    @issue.update_attribute(:status,"closed")
    flash[:notice] = "Issue Closed"
    redirect_to("/issues")
  end

  def edit_user_details
    
  end

  def update_user_details
    @user = User.find_by_id(current_user.id)
    @user.update_attributes(params[:user])
    redirect_to("/issues/user_details/"+ current_user.id.to_s)
  end

end

class IssuesController < ApplicationController
  before_filter :login_required

  def index
    @bugs = Issue.find_all_by_issue_type("Bug", :order => "id DESC")#.group_by &:status
    @features = Issue.find_all_by_issue_type("Feature",:order => "id DESC")#.group_by &:status
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
    @issue.assigned_to = params[:assign_to]
    @issue.status = "open"
    @issue.issue_type = params[:type]
    @issue.save
    flash[:notice] = "New Issue Added"
    redirect_to("/issues")
  end

  def update
    @issue = Issue.find(params[:id])
    @issue.update_attributes(params[:issue])
    @issue.update_attribute(:status,params[:status])
    @issue.update_attribute(:assigned_to,params[:assign_to])
    redirect_to("/issues")
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    redirect_to("/issues/my_issues/"+current_user.id.to_s)
  end

  def my_issues
    @bugs = Issue.find_all_by_issue_type_and_assigned_to("Bug",current_user.id,:order => "id DESC")#.group_by &:status
    @features = Issue.find_all_by_issue_type_and_assigned_to("Feature",current_user.id,:order => "id DESC")#.group_by &:status
  end

  def user_details
    @users = User.all
  end

  def user_issues
    @bugs = Issue.find_all_by_issue_type_and_assigned_to("Bug",params[:id],:order => "id DESC")#.group_by &:status
    @features = Issue.find_all_by_issue_type_and_assigned_to("Feature",params[:id],:order => "id DESC")#.group_by &:status
    @user = User.find_by_id(params[:id])
  end

  def close_issue
    @issue = Issue.find_by_id(params[:id])
    @issue.update_attribute(:status,"closed")
    flash[:notice] = "Issue Closed"
    redirect_to("/issues")
  end

  def edit_user_details
    @user = User.find_by_id(params[:id])
  end

  def update_user_details
    @user = User.find_by_id(current_user.id)
    @user.update_attributes(params[:user])
    flash[:notice] = "User Details Updated"
    redirect_to("/issues/edit_user_details/"+ current_user.id.to_s)
  end

  def destroy_user
    @user = User.find_by_id(params[:id])
    @user.destroy
    redirect_to("/issues/user_details/"+ current_user.id.to_s)
  end

end
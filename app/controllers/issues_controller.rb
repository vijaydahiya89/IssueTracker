class IssuesController < ApplicationController
  before_filter :login_required

  def index
    #objects for all issue page with the type of bugs ,features, enhancements , tasks ,questions
    @open_bugs = Issue.find_all_by_issue_type_and_status("Bug","open",:order => "id DESC")
    @solved_bugs = Issue.find_all_by_issue_type_and_status("Bug","solved",:order => "id DESC")
    @tested_bugs = Issue.find_all_by_issue_type_and_status("Bug","tested",:order => "id DESC")
    @closed_bugs = Issue.find_all_by_issue_type_and_status("Bug","closed",:order => "id DESC")

    @open_features = Issue.find_all_by_issue_type_and_status("Feature","open",:order => "id DESC")
    @devcomplete_features = Issue.find_all_by_issue_type_and_status("Feature","devcomplete",:order => "id DESC")
    @tested_features = Issue.find_all_by_issue_type_and_status("Feature","tested",:order => "id DESC")
    @closed_features = Issue.find_all_by_issue_type_and_status("Feature","closed",:order => "id DESC")

    @open_enhancements = Issue.find_all_by_issue_type_and_status("Enhancement","open",:order => "id DESC")
    @devcomplete_enhancements = Issue.find_all_by_issue_type_and_status("Enhancement","devcomplete",:order => "id DESC")
    @tested_enhancements = Issue.find_all_by_issue_type_and_status("Enhancement","tested",:order => "id DESC")
    @closed_enhancements = Issue.find_all_by_issue_type_and_status("Enhancement","closed",:order => "id DESC")

    @open_tasks = Issue.find_all_by_issue_type_and_status("Task","open",:order => "id DESC")
    @closed_tasks = Issue.find_all_by_issue_type_and_status("Task","closed",:order => "id DESC")

    @open_questions = Issue.find_all_by_issue_type_and_status("Question","open",:order => "id DESC")
    @answered_questions = Issue.find_all_by_issue_type_and_status("Question","answered",:order => "id DESC")
  end

  def show
    @issue = Issue.find(params[:id])
    @user = User.find_by_id(@issue.assigned_to)
    @posts = Post.find_all_by_issue_id(params[:id])
    if params[:from] != "posts"
      @visit = Visit.find_by_user_id_and_issue_id(current_user.id,@issue.id)
      @visit.update_attribute(:visited_at,Time.now)
    end
  end

  def new
    @issue = Issue.new
  end

  def edit
    @issue = Issue.find(params[:id])
  end

  def create
    @issue = current_user.issues.create(params[:issue])
    @issue.short_description = params[:summary]
    @issue.status = "open"
    @issue.save
    @user = User.find(@issue.assigned_to)
    @all_users = User.all
    @all_users.each do |user|
      @visit = Visit.new
      @visit.user_id = user.id
      @visit.issue_id = @issue.id
      @visit.visited_at = Time.now
      @visit.save
    end
    flash[:notice] = "Issue Added"
    UserMailer.deliver_send_new_issue(@issue,@user)
    redirect_to("/issues/user_issues/#{current_user.id}")
  end

  def update
    @issue = Issue.find(params[:id])
    @issue.update_attributes(params[:issue])
    redirect_to("/issues/user_issues/#{current_user.id}")
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    @visits = Visit.find_all_by_issue_id(params[:id])
    @visits.each do |visit|
      visit.destroy
    end
    redirect_to("/issues/user_issues/#{current_user.id}")
  end

  def my_issues
    #objects for my_issue  page with the type of bugs ,features, enhancements , tasks ,questions
    @open_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","open",:order => "id DESC")
    @solved_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","solved",:order => "id DESC")
    @tested_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","tested",:order => "id DESC")
    @closed_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","closed",:order => "id DESC")

    @open_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","open",:order => "id DESC")
    @devcomplete_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","devcomplete",:order => "id DESC")
    @tested_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","tested",:order => "id DESC")
    @closed_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","closed",:order => "id DESC")

    @open_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","open",:order => "id DESC")
    @devcomplete_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","devcomplete",:order => "id DESC")
    @tested_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","tested",:order => "id DESC")
    @closed_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","closed",:order => "id DESC")

    @open_tasks = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Task","open",:order => "id DESC")
    @closed_tasks = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Task","closed",:order => "id DESC")

    @open_questions = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Question","open",:order => "id DESC")
    @answered_questions = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Question","answered",:order => "id DESC")
  end  

  def my_bugs
    @open_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","open",:order => "id DESC")
    @solved_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","solved",:order => "id DESC")
    @tested_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","tested",:order => "id DESC")
    @closed_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","closed",:order => "id DESC")
  end

  def my_features
    @open_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","open",:order => "id DESC")
    @devcomplete_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","devcomplete",:order => "id DESC")
    @tested_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","tested",:order => "id DESC")
    @closed_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","closed",:order => "id DESC")
  end

  def my_enhancements
    @open_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","open",:order => "id DESC")
    @devcomplete_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","devcomplete",:order => "id DESC")
    @tested_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","tested",:order => "id DESC")
    @closed_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","closed",:order => "id DESC")
  end

  def my_tasks
    @open_tasks = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Task","open",:order => "id DESC")
    @closed_tasks = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Task","closed",:order => "id DESC")
  end

  def my_questions
    @open_questions = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Question","open",:order => "id DESC")
    @answered_questions = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Question","answered",:order => "id DESC")
  end

  def user_issues
    @users = User.find_all_by_user_id(2422,:order => 'login')
  end
  
  def user_bugs
    @users = User.find_all_by_user_id(2422,:order => 'login')
  end
  
  def user_features
    @users = User.find_all_by_user_id(2422,:order => 'login')
  end
  
  def user_enhancements
    @users = User.find_all_by_user_id(2422,:order => 'login')
  end
  
  def user_tasks
    @users = User.find_all_by_user_id(2422,:order => 'login')
  end
  
  def user_questions
    @users = User.find_all_by_user_id(2422,:order => 'login')
  end

  def update_issue_status
    #updating the status of the issue from open,solved,tested,closed
    @issue = Issue.find_by_id(params[:id])
    @issue.update_attribute(:status,params[:status])
    flash[:notice] = "Status Updated"
    @user = User.find_by_id(@issue.assigned_to)
    #Comment being added after the update of the status
    comment = "Status updated to #{@issue.status} on #{Time.now}"
    @post = Post.new
    @post.message = comment
    @post.user_id = current_user.id
    @post.issue_id = @issue.id
    @post.save
    #sending the mail to the user for the status update
    UserMailer.deliver_send_comment_to_assigned_to_for_status(@post,@user,@issue)
    redirect_to("/issues")
  end

  def reassign
    #Code for reassigning of the issue
    @issue = Issue.find_by_id(params[:id])
    @issue.update_attribute(:assigned_to, params[:issue][:assigned_to])
    @user = User.find_by_id(@issue.assigned_to)
    #Adding a comment giving info about the reassigning of the issue.
    comment = "This issue was reassigned to #{@user.login} on #{Time.now}"
    @post = Post.new
    @post.message = comment
    @post.user_id = current_user.id
    @post.issue_id = @issue.id
    @post.save
    #sending the mail to the person to whom the issue is being assigned to.
    UserMailer.deliver_send_new_issue(@issue,@user)
    redirect_to("/issues/user_issues/#{current_user.id}")
  end

  def edit_user_details
    
  end

  def update_user_details
    @user = User.find_by_id(current_user.id)
    @user.update_attributes(params[:user])
    flash[:notice]= "Details Updated"
    redirect_to("/issues/edit_user_details/"+ current_user.id.to_s)
  end

  def update_visits
    @issues = Issue.all
    @issues.each do |issue|
      @visit = Visit.new
    #  @visit.user_id = user.id       # replace RHS with new user's id after his/her signup
      @visit.issue_id = issue.id
      @visit.visited_at = "2011-06-02 02:28:31"
      @visit.save
    end
    flash[:notice]= "Visits Updated"
    redirect_to("/issues/user_issues/#{current_user.id}")
  end

end

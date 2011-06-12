class IssuesController < ApplicationController
  before_filter :login_required

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

  def new_feature
    @issue = Issue.new
  end

  def new_enhancement
    @issue = Issue.new
  end

  def new_task
    @issue = Issue.new
  end

  def new_query
    @issue = Issue.new
  end

  def edit
    @issue = Issue.find(params[:id])
  end

  def create
    @issue = current_user.issues.create(params[:issue])
    @issue.short_description = params[:summary]
    @issue.detailed_description = params[:detailed_description]
    @issue.status = "Open"
    @issue.save
    @user = User.find(@issue.assigned_to)
#    @all_users = User.find_all_by_user_id(2422)  # for staging
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
    @bugs = Issue.find_all_by_assigned_to_and_issue_type(current_user.id,"Bug",:order => "id DESC")
    @features = Issue.find_all_by_assigned_to_and_issue_type(current_user.id,"Feature",:order => "id DESC")
    @enhancements = Issue.find_all_by_assigned_to_and_issue_type(current_user.id,"Enhancement",:order => "id DESC")
    @tasks = Issue.find_all_by_assigned_to_and_issue_type(current_user.id,"Task",:order => "id DESC")
    @queries = Issue.find_all_by_assigned_to_and_issue_type(current_user.id,"Query",:order => "id DESC")

    @open_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","Open",:order => "id DESC")
    @fixed_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","Fixed",:order => "id DESC")
    @tested_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","Tested",:order => "id DESC")
    @closed_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","Closed",:order => "id DESC")

    @open_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","Open",:order => "id DESC")
    @devdone_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","Devdone",:order => "id DESC")
    @tested_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","Tested",:order => "id DESC")
    @closed_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","Closed",:order => "id DESC")

    @open_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","Open",:order => "id DESC")
    @devdone_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","Devdone",:order => "id DESC")
    @tested_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","Tested",:order => "id DESC")
    @closed_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","Closed",:order => "id DESC")

    @open_tasks = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Task","Open",:order => "id DESC")
    @done_tasks = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Task","Done",:order => "id DESC")

    @open_queries = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Query","Open",:order => "id DESC")
    @answered_queries = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Query","Answered",:order => "id DESC")
  end  

  def my_bugs
    @bugs = Issue.find_all_by_assigned_to_and_issue_type(current_user.id,"Bug",:order => "id DESC")
    @open_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","Open",:order => "id DESC")
    @fixed_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","Fixed",:order => "id DESC")
    @tested_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","Tested",:order => "id DESC")
    @closed_bugs = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Bug","Closed",:order => "id DESC")
  end

  def my_features
    @features = Issue.find_all_by_assigned_to_and_issue_type(current_user.id,"Feature",:order => "id DESC")
    @open_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","Open",:order => "id DESC")
    @devdone_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","Devdone",:order => "id DESC")
    @tested_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","Tested",:order => "id DESC")
    @closed_features = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Feature","Closed",:order => "id DESC")
  end

  def my_enhancements
    @enhancements = Issue.find_all_by_assigned_to_and_issue_type(current_user.id,"Enhancement",:order => "id DESC")
    @open_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","Open",:order => "id DESC")
    @devdone_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","Devdone",:order => "id DESC")
    @tested_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","Tested",:order => "id DESC")
    @closed_enhancements = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Enhancement","Closed",:order => "id DESC")
  end

  def my_tasks
    @tasks = Issue.find_all_by_assigned_to_and_issue_type(current_user.id,"Task",:order => "id DESC")
    @open_tasks = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Task","Open",:order => "id DESC")
    @done_tasks = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Task","Done",:order => "id DESC")
  end

  def my_queries
    @queries = Issue.find_all_by_assigned_to_and_issue_type(current_user.id,"Query",:order => "id DESC")
    @open_queries = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Query","Open",:order => "id DESC")
    @answered_queries = Issue.find_all_by_assigned_to_and_issue_type_and_status(current_user.id,"Query","Answered",:order => "id DESC")
  end

  def user_issues
#    @users = User.find_all_by_user_id(2422,:order => 'login')   # on staging
    @users = User.all(:order => 'login')
  end
  
  def user_bugs
#    @users = User.find_all_by_user_id(2422,:order => 'login')   # on staging
    @users = User.all(:order => 'login')
  end
  
  def user_features
#    @users = User.find_all_by_user_id(2422,:order => 'login')   # on staging
    @users = User.all(:order => 'login')
  end
  
  def user_enhancements
#    @users = User.find_all_by_user_id(2422,:order => 'login')   # on staging
    @users = User.all(:order => 'login')
  end
  
  def user_tasks
#    @users = User.find_all_by_user_id(2422,:order => 'login')   # on staging
    @users = User.all(:order => 'login')
  end
  
  def user_queries
#    @users = User.find_all_by_user_id(2422,:order => 'login')   # on staging
    @users = User.all(:order => 'login')
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
#    UserMailer.deliver_send_comment_to_assigned_to_for_status(@post,@user,@issue)
    redirect_to("/issues/user_issues/#{current_user.id}")
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
#    UserMailer.deliver_send_new_issue(@issue,@user)
    redirect_to("/issues/user_issues/#{current_user.id}")
  end

  def edit_user_details
    
  end

  def update_user_details
    @user = User.find_by_id(current_user.id)
    @user.update_attributes(params[:user])
    flash[:notice]= "Details Updated"
    redirect_to("/issues/edit_user_details/#{current_user.id}")
  end

  def update_visits
    @issues = Issue.all
    @issues.each do |issue|
      @visit = Visit.new
      @visit.user_id = params[:id]   # params[:id] is the new user's id after his/her signup
      @visit.issue_id = issue.id
      @visit.visited_at = "2011-06-02 02:28:31"
      @visit.save
    end
    flash[:notice]= "Visits Updated"
    redirect_to("/issues/user_issues/#{current_user.id}")
  end

end

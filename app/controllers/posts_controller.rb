class PostsController < ApplicationController

  def create
    @post = Post.new
    @post.message = params[:message]
    @post.user_id = current_user.id
    @post.issue_id = params[:id]
    @post.save
    @issue = Issue.find(params[:id])
    @user = User.find_by_id(@issue.assigned_to)
    @posts = Post.find_all_by_issue_id(params[:id])
    all_users = Array.new
    @posts.each do |post|
      unless all_users.include?(User.find(post.user_id)) then
        all_users << User.find(post.user_id)
      end
    end
    if params[:from] != "posts"
      @visit = Visit.find_by_user_id_and_issue_id(current_user.id,@issue.id)
      @visit.update_attribute(:visited_at,Time.now)
    end
    all_users.each{ |user|
#      UserMailer.deliver_send_new_comment(@posts.last,user,@issue)
    }
#    UserMailer.deliver_send_new_comment_to_assigned_to(@posts.last,@user,@issue)
    redirect_to("/issues/show/#{params[:id]}?from=posts")
  end

  def delete
    @post = Post.find(params[:id])
    issue_id = @post.issue_id
    @post.destroy
    redirect_to("/issues/show/"+issue_id.to_s)
  end

end


















class PostsController < ApplicationController

  def create
      @post = Post.new
      @post.message = params[:message]
      @post.user_id = current_user.id
      @post.issue_id = params[:id]
      @post.save
      all_users = Array.new
      @issue = Issue.find(params[:id])
      @posts = Post.find_all_by_issue_id(params[:id])
      @user = User.find_by_id(@issue.assigned_to)
      @posts.each do |post|
        unless all_users.include?(User.find(post.user_id)) then
          all_users << User.find(post.user_id)
        end
      end
      unless all_users.include?(@user)
        all_users << @user
      end
      all_users.each do |user|
        UserMailer.deliver_send_new_comment(@posts.last,user,@issue)
      end
      redirect_to("/issues/show/#{params[:id]}?from=posts")
  end

  def destroy
    @post = Post.find(params[:id])
    issue_id = @post.issue_id
    @post.destroy
    redirect_to("/issues/show/#{issue_id.to_s}?from=posts")
  end

end


















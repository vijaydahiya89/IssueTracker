class PostsController < ApplicationController

  def create
    @posts = Post.find_all_by_issue_id(params[:id])
    @issue = Issue.find(params[:id])
    flag = 0
    if @posts.empty?
      if current_user.id == @issue.user_id
        merged_description = @issue.detailed_description + "\n\n" + params[:message]
        @issue.update_attribute(:detailed_description, merged_description)
      else
        flag = 1
      end
    else
      if current_user.id == @posts.last.user_id
        merged_comment = @posts.last.message + "\n\n" + params[:message]
        @posts.last.update_attribute(:message, merged_comment)
      else
        flag = 1
      end
    end
    if flag == 1
      @post = Post.new
      @post.message = params[:message]
      @post.user_id = current_user.id
      @post.issue_id = params[:id]
      @post.save
      all_users = Array.new
      @posts.each do |post|
        unless all_users.include?(User.find(post.user_id)) then
          all_users << User.find(post.user_id)
        end
      end
      @user = User.find_by_id(@issue.assigned_to)
      unless all_users.include?(@user)
        all_users << @user
      end
      all_users.each do |user|
        UserMailer.deliver_send_new_comment(@posts.last,user,@issue)
      end
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


















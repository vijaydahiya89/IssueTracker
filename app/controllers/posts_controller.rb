class PostsController < ApplicationController

  def create
    @post = Post.new
    @post.message = params[:message]
    @post.user_id = current_user.id
    @post.issue_id = params[:id]
    @post.save
    redirect_to("/issues/show/#{params[:id]}?from=posts")
  end

  def delete
    @post = Post.find(params[:id])
    issue_id = @post.issue_id
    @post.destroy
    redirect_to("/issues/show/"+issue_id.to_s)
  end

end


















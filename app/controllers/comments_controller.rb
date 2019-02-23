class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:show, :destroy]
  def index
    @comments = @post.comments
    render json: @comments, each_serializer: CommentSerializer
  end

  def show
    if @comment
      render json: @comment
    else
      render json: {:data => nil}, status: :not_found
    end
  end

  def create
    @comment = @post.comments.new(comment_params) 
    if @comment.save
      render json: @comment, status: :created
    else
      render json: {:errors => @comment.errors.messages}, status: :bad_request
    end
  end

  def destroy
     if @comment && @comment.destroy
       render status: :no_content
     else
       render json: {:data => nil}, status: :not_found
     end
  end

  private
  def set_post
    @post = Post.find_by(id: params[:post_id])
  end

  def set_comment
    @comment = Comment.find_by(id: params[:id])
  end

  def comment_params
    params.permit(:post_id, :user_id, :body)
  end
end

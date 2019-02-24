class CommentsController < ApplicationController
  include Authenticable

  before_action :set_post
  before_action :set_comment, only: [:show, :destroy]
  before_action :set_commenter, only: [:create, :destroy]

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
    @comment = @commenter.comments.new(comment_params)
    if @comment.save
      render json: @comment, status: :created
    else
      render json: {:errors => @comment.errors.messages}, status: :bad_request
    end
  end

  # TODO: only the commenter should be able to delete comment
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

  def set_commenter
    @commenter = set_user
  end

  def comment_params
    params.permit(:post_id, :body)
  end
end

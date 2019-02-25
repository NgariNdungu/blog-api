class CommentsController < ApplicationController
  include Authenticable
  require_relative 'decorators/errors_decorator'

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
      render json: SerializedError.new(@comment).not_found, status: :not_found
    end
  end

  def create
    @comment = @commenter.comments.new(comment_params)
    if @comment.save
      render json: @comment, status: :created
    else
      render json: SerializedError.new(@comment.errors).bad_request, status: :bad_request
    end
  end

  def destroy
    if @comment.commenter == @commenter
      if @comment && @comment.destroy
        render status: :no_content
      else
        render json: SerializedError.new(@comment.errors).not_found, status: :not_found
      end
    else
      render json: SerializedError.new(@comment.errors).unauthorized, status: :unauthorized
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
    if @commenter.nil?
      render json: SerializedError.new(nil).unauthorized, status: :unauthorized
    end
  end

  def comment_params
    params.permit(:post_id, :body)
  end
end

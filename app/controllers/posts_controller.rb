class PostsController < ApplicationController
  include Authenticable
  before_action :set_post, only: [:update, :show, :destroy]
  before_action :set_author, except: [:index, :show]

  def index
    @posts = Post.all # TODO: handle pagination
    render json: @posts, each_serializer: PostSerializer
  end

  def show
    if @post
      render json: @post
    else
      render json: {:data => nil}, status: :not_found
    end
  end

  def create
    @post = @author.posts.new(post_params)
    if @post.save
      render json: @post
    else
      render json: {:errors => @post.errors.messages}, status: :bad_request
    end
  end

  # TODO: handle case when user is not the author
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: {:errors => @post.errors.messages}, status: :bad_request
    end
  end

  def destroy
    if !@post.nil? && @post.destroy
      render status: :no_content
    else
      render status: :not_found
    end
  end

  private
  def post_params
    params.permit(:title, :text, :user_id)
  end

  def set_post
    @post = Post.find_by(id: params[:id])
  end

  def set_author
    @author = set_user
  end
end

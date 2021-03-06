class PostsController < ApplicationController
  include Authenticable
  require_relative 'decorators/errors_decorator'

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
      render json: SerializedError.new(nil).not_found , status: :not_found
    end
  end

  def create
    @post = @author.posts.new(post_params[:attributes])
    if @post.save
      render json: @post
    else
      render json: SerializedError.new(@post.errors).unauthorized, status: :bad_request
    end
  end

  def update
    if is_author?
      if @post.update(post_params[:attributes])
        render json: @post
      else
        render json: SerializedError.new(@post.errors).unauthorized, status: :bad_request
      end
    end
  end

  def destroy
    if is_author?
      if @post.destroy
        render status: :no_content
      else
        render status: :not_found
      end
    end
  end

  private
  def post_params
    # TODO: handle actioncontroller errors on missing params
    params.require(:data).permit(:type, attributes: {}).tap do |postParams|
      postParams.require([:attributes, :type])[0].permit(:title, :text, :user_id)
    end
  end

  def set_post
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      render json: SerializedError.new(nil).not_found, status: :not_found
    end
  end

  def set_author
    @author = set_user
    if @author.nil?
      render json: SerializedError.new(nil).unauthorized, status: :unauthorized
    end
  end

  def is_author?
    if @post.author == @author
      true
    else
      render json: SerializedError.new(nil).unauthorized, status: :unauthorized
      false
    end
  end
end

class UsersController < ApplicationController
  require_relative 'decorators/errors_decorator'
  def create
    @user = User.new(user_params[:attributes])    
    if @user.save
      render json: @user
    else
      render json: SerializedError.new(@user.errors).bad_request, status: :bad_request
    end
  end

  private
  def user_params
    params.require(:data).permit(:type, attributes: {}).tap do |userParams|
      userParams.require([:attributes, :type])[0].permit(:username, :full_name, :password)
    end
  end
end

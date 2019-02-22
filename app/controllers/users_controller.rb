class UsersController < ApplicationController
  def create
    @user = User.new(user_params)    
    if @user.save
      render json: @user
    else
      render json: {"errors": @user.errors.messages.to_json}, status: :bad_request
    end
  end

  private
  def user_params
    params.permit(:username, :full_name, :password)
  end
end

class UsersController < ApplicationController
  def create
    @user = User.new(user_params[:attributes])    
    if @user.save
      render json: @user
    else
      render json: {"errors": @user.errors.messages.to_json}, status: :bad_request
    end
  end

  private
  def user_params
    params.require(:data).permit(:type, attributes: {}).tap do |userParams|
      userParams.require([:attributes, :type])[0].permit(:username, :full_name, :password)
    end
  end
end

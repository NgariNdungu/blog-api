module Authenticable
  include ActionController::HttpAuthentication::Basic
  include ActiveSupport::Concern
  def set_user
    if has_basic_credentials?(request)
      username,password = user_name_and_password(request)
      user = User.find_by(username: username)
      if user.authenticate(password)
        @user = user
      end
    else
      @user = nil
    end
  end
end

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should create user' do
    assert_difference('User.count') do
      post users_url, params: request_params("user", attributes_for(:user)),
        headers: {"Accept": "application/vnd.api+json"}
    end
    assert_match /data/, @response.body, "Did not return created object"
  end

  test 'should return errors if user invalid' do
    invalid_params = request_params("user", attributes_for(:user, username: nil))
    post users_url, params: invalid_params
    assert_match /errors/, @response.body, "Did not return errors"
  end

end

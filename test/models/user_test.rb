require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should create user with valid details' do
    assert_difference('User.count') do
      create(:user)
    end
  end

  test 'should not create user with missing data' do
    user = User.create
    assert user.invalid?, "Should not save user with missing details"
    assert user.errors[:username].present?, "Should have error for empty username"
    assert user.errors[:password].present?, "Should have error for empty password"

  end

  test 'user should have posts' do
    assert_respond_to create(:user), :posts, "User should have posts"
  end

  test 'user should have comments' do
    assert_respond_to create(:user), :comments, "User should have comments"
  end

  test 'should not save user with duplicate username' do
    user = create(:user)
    dup_user = User.create(username: user.username, password: "password", full_name: "full name")
    assert_not dup_user.save, "Should not save user with existing username"
  end
end

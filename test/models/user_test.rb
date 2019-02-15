require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should create user with valid details' do
    assert_difference('User.count') do
      create(:user)
    end
  end

  test 'should not create user with missing data' do
    assert_not build(:user, username: "").save, "Saved a user without a username"
    assert_not build(:user, full_name: "").save, "Saved a user without a name"
    assert_not build(:user, password: "").save, "Saved a user without a password"
  end
end

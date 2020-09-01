require 'test_helper'

class UserDestroyTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "admin user can destroy other users" do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to root_url
  end

  test "non admin user can destroy self account" do
    log_in_as(@other_user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to root_url
  end

end

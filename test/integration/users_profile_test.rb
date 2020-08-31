require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "profile display" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'div.user-name', text: @user.name
    assert_match @user.microposts.count.to_s, response.body
    @user.microposts.each do |micropost|
      assert_match micropost.content, response.body
    end
  end
  
end

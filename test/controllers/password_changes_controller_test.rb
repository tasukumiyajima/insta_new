require 'test_helper'

def setup
  @user = users(:michael)
end


class PasswordChangesControllerTest < ActionDispatch::IntegrationTest
  test "redirect to root_url when not logged in" do
    get edit_password_change_path(@user)
    assert_redirected_to root_url
  end

end

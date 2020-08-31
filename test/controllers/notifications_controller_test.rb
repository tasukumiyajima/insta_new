require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest

  test "index should require logged-in user" do
    get notifications_path
    assert_redirected_to root_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Notification.count' do
      delete notification_path(notifications(:follow))
    end
    assert_redirected_to root_url
  end

end

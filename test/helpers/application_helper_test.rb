require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "insta_copyapp"
    assert_equal full_title("Help"), "Help | insta_copyapp"
  end
end
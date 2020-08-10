require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "Instagram"
    assert_equal full_title("Help"), "Help • Instagram"
  end
end
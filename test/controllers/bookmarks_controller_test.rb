require 'test_helper'

class BookmarksControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "show should require logged-in user" do
    get bookmark_path(@user)
    assert_redirected_to root_url
  end

  test "create should require logged-in user" do
    assert_no_difference 'Bookmark.count' do
      post bookmarks_path
    end
    assert_redirected_to root_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Bookmark.count' do
      delete bookmark_path(bookmarks(:one))
    end
    assert_redirected_to root_url
  end
  
end

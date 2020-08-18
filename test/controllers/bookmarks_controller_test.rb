require 'test_helper'

class BookmarksControllerTest < ActionDispatch::IntegrationTest

  test "create should require logged-in user" do
    assert_no_difference 'Bookmark.count' do
      post bookmarks_path
    end
    assert_redirected_to root_url
  end

  # test "destroy should require logged-in user" do
  #   assert_no_difference 'Bookmark.count' do
  #     delete Bookmark_path(bookmarks(:one))
  #   end
  #   assert_redirected_to root_url
  # end


end

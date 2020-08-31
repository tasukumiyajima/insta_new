require 'test_helper'

class BookmarkInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @micropost = microposts(:tone) #lanaの投稿
    log_in_as(@user)
  end

  test "user cannot access to other_user's bookmark show" do
    get bookmark_path(@user)
    assert_template 'bookmarks/show'
    get bookmark_path(@other_user)
    assert_redirected_to root_url
  end

  test "should bookmark a user the standard way" do
    get root_path
    assert_difference '@micropost.bookmarks.count', 1 do
      post bookmarks_path, params: { micropost_id: @micropost.id }
    end
    assert_redirected_to root_path
    bookmark = Bookmark.find_by(user_id: @user.id, micropost_id: @micropost.id)
    assert_difference '@micropost.bookmarks.count', -1 do
      delete bookmark_path(bookmark)
    end
    assert_redirected_to root_path  
  end

  test "associated bookmark should be destroyed when user destroy" do
    log_in_as(@user)
    lana = users(:lana)
    assert_difference 'Bookmark.count', -1 do
      lana.destroy
    end
  end

end

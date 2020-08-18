require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase
  def setup
    @bookmark = Bookmark.new(user_id: users(:michael).id,
                                     micropost_id: microposts(:zone).id)
  end

  test "should be valid" do
    assert @bookmark.valid?
  end

  test "should require a user_id" do
    @bookmark.user_id = nil
    assert_not @bookmark.valid?
  end

  test "should require a micropost_id" do
    @bookmark.micropost_id = nil
    assert_not @bookmark.valid?
  end
end

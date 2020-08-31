require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  
  def setup
    @notification_follow = notifications(:follow)
    @notification_bookmark = notifications(:bookmark)
    @notification_comment = notifications(:comment)
  end

  test "should be valid" do
    assert @notification_follow.valid?
    assert @notification_bookmark.valid?
    assert @notification_comment.valid?
  end

  test "should require a visitor_id" do
    @notification_follow.visitor_id = nil
    assert_not @notification_follow.valid?
    @notification_bookmark.visitor_id = nil
    assert_not @notification_bookmark.valid?
    @notification_comment.visitor_id = nil
    assert_not @notification_comment.valid?
  end

  test "should require a visited_id" do
    @notification_follow.visited_id = nil
    assert_not @notification_follow.valid?
    @notification_bookmark.visited_id = nil
    assert_not @notification_bookmark.valid?
    @notification_comment.visited_id = nil
    assert_not @notification_comment.valid?
  end

  test "should be correct action values" do
    @notification_follow.action = "micropost"
    assert_not @notification_follow.valid?
  end

end

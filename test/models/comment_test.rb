require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @micropost = microposts(:ants) #archerの投稿
    @comment = comments(:apple) #archerのzoneという投稿へのコメント
  end

  test "should be valid" do 
    assert @comment.valid?
  end

  test "user id should be present" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test "micropost should be present" do
    @comment.micropost_id = nil
    assert_not @comment.valid?
  end

  test "content should be present" do
    @comment.content = "   "
    assert_not @micropost.valid?
  end

end

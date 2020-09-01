require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    picture = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpg')
    @micropost = @user.microposts.build(picture: picture)
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "images should be present" do
    @micropost.picture = nil
    assert_not @micropost.valid?
  end

  test "content should be ok if not present" do
    @micropost.content = "   "
    assert @micropost.valid?
  end

  test "content should be ok if over 140 characters" do
    @micropost.content = "a" * 141
    assert @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

  test "associated comments should be destroyed" do
    @user.save
    @micropost.save
    @user.comments.create!(content: "hello",  micropost_id: @micropost.id)
    @user.comments.create!(content: "hello",  micropost_id: @micropost.id)
    assert_difference 'Comment.count', -2 do
      @micropost.destroy
    end
  end

end


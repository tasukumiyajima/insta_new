require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange) #michaelの投稿
    @comment = comments(:apple) #投稿zone(投稿したユーザーはarcher)へのmichaelのコメント
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Comment.count' do
      post micropost_comments_path(@micropost.id), params: { comment: { content: "arigato" } }
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Comment.count' do
      delete micropost_comment_path(@comment.micropost_id, @comment.id)
    end
    assert_redirected_to root_url
  end

  test "valid comment create" do
    log_in_as(users(:michael))
    get root_path
    assert_difference 'Comment.count', 1 do
      post micropost_comments_path(@micropost.id), params: { comment: {content: "arigato" } }
    end
    assert_redirected_to root_url
  end

  test "valid delete comment of myself" do
    log_in_as(users(:michael))
    get root_path
    assert_difference 'Comment.count', -1 do
      delete micropost_comment_path(@comment.micropost_id, @comment.id)
    end
    assert_redirected_to root_url
  end

  test "valid delete comment of self micropost" do
    log_in_as(users(:archer))
    get root_path
    assert_difference 'Comment.count', -1 do
      delete micropost_comment_path(@comment.micropost_id, @comment.id)
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:lana))
    assert_no_difference 'Comment.count' do
      delete micropost_comment_path(@comment.micropost_id, @comment.id)
    end
    assert_redirected_to root_url
  end

end


require 'test_helper'

class CommentsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @micropost = microposts(:ants) #archerの投稿
    @comment = @user.comments.build(content: "Lorem ipsum", micropost_id: @micropost.id) #michaelがarcherの投稿にコメント
  end

  test "comment interface" do
    log_in_as(@user)
    get root_path
    # 無効な送信
    assert_no_difference 'Comment.count' do
      post micropost_comments_path(@micropost.id), params: { comment: {content: "" } }
    end
    # 有効な送信
    assert_difference 'Comment.count', 1 do
      post micropost_comments_path(@micropost.id), params: { comment: {content: "arigato" } }
    end
    # get user_path(@user)
    # assert_match assigns(:comment).content, response.body
    # 投稿を削除する
    # assert_select 'a', text: 'コメントを削除'
    # assert_difference 'Comment.count', -1 do
    #   delete micropost_comment_path(@comment.micropost_id, @comment.id)
    # end
    # # 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
    # get user_path(users(:archer))
    # assert_select 'a', text: 'コメントを削除', count: 0
  end

end

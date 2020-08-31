require 'test_helper'

class CommentsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @micropost = microposts(:music) #archerの投稿
    @other_micropost = microposts(:hungry) #archerの投稿
    @comment = comments(:hello) #lanaの投稿
  end

  test "comment interface" do
    get root_path
    assert_no_difference 'Comment.count' do
      post micropost_comments_path(@micropost.id), params: { comment: {content: "arigato" } }
    end
    # ログイン後
    log_in_as(@user)
    get root_path
    # 無効な送信
    assert_no_difference 'Comment.count' do
      post micropost_comments_path(@micropost.id), params: { comment: {content: "" } }
    end
    assert_redirected_to root_url
    # 有効な送信(homepageから)
    get root_path
    assert_difference 'Comment.count', 1 do
      post micropost_comments_path(@micropost.id), params: { comment: {content: "arigato" } }
    end
    assert_redirected_to root_url
    first_comment = Comment.find_by(content: "arigato")
    # コメントを投稿していないmicropostにアクセス（削除リンクがないことを確認）
    get micropost_path(@other_micropost)
    assert_select 'a', text: '(このコメントを削除)', count: 0
    # コメントを削除する
    get micropost_path(@micropost)
    assert_match first_comment.content, response.body
    assert_select 'a', text: '(このコメントを削除)'
    assert_difference 'Comment.count', -1 do
      delete micropost_comment_path(@micropost.id, first_comment.id)
    end
    # 有効な送信(投稿個別ページから)
    get micropost_path(@micropost)
    assert_template 'microposts/show'
    assert_difference 'Comment.count', 1 do
      post micropost_comments_path(@micropost.id), params: { comment: {content: "arigato" } }
    end
  end

  test "other_user's comment to my micropost" do
    # michaelとしてログイン
    log_in_as(@user)
    get root_path
    # archerの@micropostへコメント
    assert_difference 'Comment.count', 1 do
      post micropost_comments_path(@micropost.id), params: { comment: {content: "arigato" } }
    end
    first_comment = Comment.find_by(content: "arigato")
    assert_redirected_to root_url
    follow_redirect!
    # ログアウトする
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # archerとしてログイン
    log_in_as(@other_user)
    get micropost_path(@micropost)
    assert_match first_comment.content, response.body
    # archerがmichaelのコメントを削除する
    assert_select 'a', text: '(このコメントを削除)'
    assert_difference 'Comment.count', -1 do
      delete micropost_comment_path(@micropost.id, first_comment.id)
    end
  end

  test "associated comments should be destroyed when user destroy" do
    log_in_as(@user)
    lana = users(:lana)
    assert_difference 'Comment.count', -1 do
      lana.destroy
    end
  end

end

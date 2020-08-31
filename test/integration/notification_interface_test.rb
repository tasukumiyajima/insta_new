require 'test_helper'

class NotificationInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:taro)
    @micropost = microposts(:sushi) #taroの投稿
  end

  test "no notification test" do
    log_in_as(users(:saki))
    get root_path
    assert_select "span.fa-circle", count: 0
    get notifications_path
    assert_select 'p', 'あなたがフォローされたり、あなたの投稿にコメントやお気に入りがあった場合にここに通知されます'
  end

  test "follow notification test" do 
    log_in_as(@user)
    get user_path(@other_user)
    assert_difference 'Notification.count', 1 do
      post relationships_path, params: { followed_id: @other_user.id }
    end
    assert_redirected_to @other_user
    # ログアウトする
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # taroとしてログイン
    log_in_as(@other_user)
    get root_path
    assert_select "span.fa-circle", count: 1
    get notifications_path
    assert_select 'div.delete-tag', "通知を全て削除する"
    assert_match @user.user_name, response.body
    assert_match "があなたをフォローしました", response.body
    get root_path
    assert_select "span.fa-circle", count: 0
  end

  test "boomark notification test" do 
    log_in_as(@user)
    get root_path
    assert_difference 'Notification.count', 1 do
      post bookmarks_path, params: { micropost_id: @micropost.id }
    end
    assert_redirected_to root_path
    # ログアウトする
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # taroとしてログイン
    log_in_as(@other_user)
    get root_path
    assert_select "span.fa-circle", count: 1
    get notifications_path
    assert_select 'div.delete-tag', "通知を全て削除する"
    assert_match @user.user_name, response.body
    assert_match "をお気に入りに入れました", response.body
    get root_path
    assert_select "span.fa-circle", count: 0
  end


  test "comment notification test" do 
    log_in_as(@user)
    get root_path
    assert_difference 'Notification.count', 1 do
      post micropost_comments_path(@micropost.id), params: { comment: {content: "arigato" } }
    end
    assert_redirected_to root_path
    # ログアウトする
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # taroとしてログイン
    log_in_as(@other_user)
    get root_path
    assert_select "span.fa-circle", count: 1
    get notifications_path
    assert_select 'div.delete-tag', "通知を全て削除する"
    assert_match @user.user_name, response.body
    assert_match "にコメントをしました", response.body
    get root_path
    assert_select "span.fa-circle", count: 0
  end

  test "associated notification should be destroyed when user destroy" do
    log_in_as(@user)
    lana = users(:lana)
    assert_difference 'Notification.count', -2 do
      lana.destroy
    end
  end

end


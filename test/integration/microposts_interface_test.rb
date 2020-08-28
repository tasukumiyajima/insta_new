require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    get new_micropost_path
    assert_select 'input[type="file"]'
    # 無効な送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { picture: ""} }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    picture = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpg')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { picture: picture } }
    end
    assert assigns(:micropost).picture?
    follow_redirect!
    # assert_match picture, response.body
    # 投稿を削除する
    assert_select 'a', text: '投稿を削除'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
    get user_path(users(:archer))
    assert_select 'a', text: '削除', count: 0
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get new_micropost_path
    # assert_match "投稿数：#{@user.microposts.count}", response.body
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)
    log_in_as(other_user)
    get new_micropost_path
    # assert_match "投稿数：0", response.body
    # 画像を投稿する
    picture = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpg')
    other_user.microposts.create!(picture: picture)
    get new_micropost_path
    # assert_match "投稿数：1", response.body
  end

end
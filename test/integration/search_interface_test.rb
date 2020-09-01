require 'test_helper'

class SearchInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @micropost = microposts(:sushi) #contentにsushiを含む投稿
    log_in_as(@user)
  end

  test "search method test" do
    # 空で検索
    get root_path
    assert_select "form.search-form", count: 1
    get search_path, params: { static_page: { search: "" } }
    assert_not flash.empty?
    # 正しく検索
    get root_path
    assert_select "form.search-form", count: 1
    get search_path, params: { static_page: { search: "sushi" } }
    assert_template 'static_pages/search'
    assert_match @micropost.user.user_name, response.body
    assert_match "sushi", response.body
    # 条件に一致しない
    get root_path
    assert_select "form.search-form", count: 1
    get search_path, params: { static_page: { search: "まぐろ" } }
    assert_template 'static_pages/search'
    assert_match "条件に一致する投稿は見つかりませんでした", response.body
  end

end


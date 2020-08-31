require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              user_name: "",
                                              website: "",
                                              introduction: "",
                                              email: "foo@invalid",
                                              phone_number: "",
                                              sex: "" } }
    assert_template 'users/edit'
    assert_select 'div.alert', "エラーが3つあります。"
    patch user_path(@user), params: { user: { name:  "",
                                              user_name: "",
                                              website: "aaa",
                                              introduction: "aaa",
                                              email: "foo@bar.com",
                                              phone_number: 9011111111,
                                              sex: 1 } }
    assert_template 'users/edit'
    assert_select 'div.alert', "エラーが2つあります。"
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user) 
    log_in_as(@user)
    assert_nil session[:forwarding_url]
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    user_name = "foo"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              user_name: user_name,
                                              website: "",
                                              introduction: "",
                                              email: email,
                                              phone_number: "",
                                              sex: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal user_name,  @user.user_name
    assert_equal email, @user.email
  end

  test "successful full edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    user_name = "foo"
    email = "foo@bar.com"
    website = "aaa"
    introduction = "aaa"
    phone_number = 9011111111
    sex = 1
    patch user_path(@user), params: { user: { name:  name,
                                              user_name: user_name,
                                              website: website,
                                              introduction: introduction,
                                              email: email,
                                              phone_number: phone_number,
                                              sex: sex } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal user_name,  @user.user_name
    assert_equal email, @user.email
    assert_equal website, @user.website
    assert_equal introduction, @user.introduction
    assert_equal phone_number, @user.phone_number
    assert_equal sex, @user.sex
  end

end

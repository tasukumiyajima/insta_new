require 'test_helper'

class PasswordChangesTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful and successful change" do
    # ログインしていない状態でアクセス
    get edit_password_change_path(@user)
    assert_redirected_to root_url
    # ログイン後
    log_in_as(@user)
    get edit_password_change_path(@user)
    assert_template 'password_changes/edit'
    # 現在のパスワードがブランクの場合
    patch password_change_path(@user), params: { user: { 
                                                current_password:  "",
                                                password: "foobar",
                                                password_confirmation: "foobar"} }
    # assert_template 'password_changes/edit'
    assert_redirected_to edit_password_change_path
    assert_not flash.empty?
    # 現在のパスワードが正しいが、新しいパスワードがブランクの場合
    patch password_change_path(@user), params: { user: { 
                                                current_password:  "password",
                                                password: "",
                                                password_confirmation: ""} }
    # assert_template 'password_changes/edit'
    assert_redirected_to edit_password_change_path
    assert_not flash.empty?
    # 現在のパスワードが正しいが、新しいパスワードが６文字未満の場合
    patch password_change_path(@user), params: { user: { 
                                                current_password:  "password",
                                                password: "foo",
                                                password_confirmation: "foo"} }
    # assert_template 'password_changes/edit'
    assert_redirected_to edit_password_change_path
    assert_not flash.empty?
    # 現在のパスワードが正しいが、新しいパスワードが間違っている場合
    patch password_change_path(@user), params: { user: { 
                                                current_password:  "password",
                                                password: "foobar",
                                                password_confirmation: "foobaaaaa"} }
    # assert_template 'password_changes/edit'
    assert_redirected_to edit_password_change_path
    assert_not flash.empty?
    # 正しいパスワード変更
    patch password_change_path(@user), params: { user: { 
                                                current_password:  "password",
                                                password: "foobar",
                                                password_confirmation: "foobar"} }
    assert_redirected_to @user
    assert_not flash.empty?
  end

end

class PasswordChangesController < ApplicationController
before_action :logged_in_user
before_action :correct_user

  def edit
  end

  def update
    current_password = params[:user][:password]
    if @user && @user.authenticate(current_password)
      new_password = params[:user][:new_password]
      new_password_confirmation = params[:user][:new_password_confirmation]
      if new_password == new_password_confirmation
        @user.update_attribute(:password, new_password)
        flash[:success] = "パスワードを変更しました"
        redirect_to @user
      else
        flash[:danger] = '正しく新しいパスワードを入力してください'
        render 'edit'
      end
    else
      flash[:danger] = '現在のパスワードが間違っています'
      render 'edit'
    end
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

end

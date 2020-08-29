class PasswordChangesController < ApplicationController
before_action :logged_in_user
before_action :correct_user

def edit
  end

  def update
    if @user && @user.authenticate(params[:user][:current_password])
      if params[:user][:password].empty?
        redirect_to edit_password_change_path
        flash[:danger] = "新しいパスワードを正しく入力してください(6文字以上)"
      elsif @user.update(user_params)
        flash[:success] = "パスワードを変更しました"
        redirect_to @user
      else
        redirect_to edit_password_change_path
        flash[:danger] = "新しいパスワードを正しく入力してください(6文字以上)"  
      end
    else
      redirect_to edit_password_change_path
      flash[:danger] = "現在のパスワードが間違っています"
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end

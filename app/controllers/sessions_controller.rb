class SessionsController < ApplicationController

  # ログイン時は自動的にrememberする
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      remember(@user)
      flash[:success] = 'ログインしました'
      redirect_back_or @user
    else
      flash[:danger] = '正しい情報を入力してください'
      redirect_to root_url
    end
  end

  # ログアウト時
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end


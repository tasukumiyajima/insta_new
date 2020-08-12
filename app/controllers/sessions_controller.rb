class SessionsController < ApplicationController

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or root_url
      else
        message  = "アカウントが有効化されていません。"
        message += "emailのリンクからアカウントを有効化してください。"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash[:danger] = 'メールアドレスかパスワードが正しくありません。'
      redirect_to root_url
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end


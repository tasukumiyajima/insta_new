class PasswordResetsController < ApplicationController
  # before_action :get_user,   only: [:edit, :update]
  # before_action :valid_user, only: [:edit, :update]
  # before_action :check_expiration, only: [:edit, :update] # パスワードの期限が切れていないか確認する

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest # データベースにreset_digestを保存する
      @user.send_password_reset_email #パスワードリセットのメールをユーザーに送信する
      flash[:info] = "パスワードリセットのためのemailを送付しました。"
      redirect_to root_url
    else
      flash.now[:danger] = "一致するユーザーが見つかりませんでした。"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty? # 新しいパスワードがblankだった場合
      @user.errors.add(:password, :blank) # パスワードがblankだった場合のエラーメッセージを追加する
      render 'edit'
    elsif @user.update(user_params) # 正しく更新できた場合
      log_in @user
      remember(@user)
      flash[:success] = "パスワードが再設定されました。"
      redirect_to @user
    else
      render 'edit' # パスワードが正しくない場合
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "パスワードの有効期限が切れています。"
        redirect_to new_password_reset_url
      end
    end

end

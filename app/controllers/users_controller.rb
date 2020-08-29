class UsersController < ApplicationController
before_action :logged_in_user, only: [:index, :edit, :update, :destroy, 
                                      :following, :followers]
before_action :correct_user,   only: [:edit, :update]
before_action :admin_user_or_correct_user, only: :destroy

  def facebook_login
    @user = User.from_omniauth(request.env["omniauth.auth"])
    result = @user.save
    if result
      log_in @user
      remember(@user)
      redirect_to @user
      flash[:success] = 'ログインしました'
    else
      redirect_to auth_failure_path
      flash[:danger] = 'ログインできません'
    end
  end

  # FB認証に失敗した際の処理
  def auth_failure 
    redirect_to root_path
  end

  # ユーザー一覧ページ
  def index
    @users = User.paginate(page: params[:page])
  end

  # ユーザーの個別ベージ
  def show
    @user=User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @comment = current_user.comments.build if logged_in?
  end

  # ユーザーのお気に入りベージ
  def bookmark_show
    @user = current_user
    @microposts = current_user.microposts.paginate(page: params[:page])
    @comment = current_user.comments.build if logged_in?
  end

  # ユーザー登録
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      remember(@user)
      flash[:success] = "アカウントが作成されました"
      redirect_to @user
    else
      render 'new'
    end
  end

  # プロフィール編集
  def edit
  end

  def update
    if @user.update(user_profile_params)
      flash[:success] = "プロフィールを更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを消去しました。"
    redirect_to root_url
  end

  def following
    @title = "フォロー中"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  private

    def user_params
      params.require(:user).permit(:password, :email, :name, :user_name )
    end

    def user_profile_params
      params.require(:user).permit(:email, :name, :user_name, 
                            :website, :introduction, :phone_number, :sex, :fb_password_set)
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user_or_correct_user
      @user = User.find(params[:id])
      unless current_user?(@user) || current_user.admin?
      redirect_to(root_url)
      end
    end

end


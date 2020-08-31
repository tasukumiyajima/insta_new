class BookmarksController < ApplicationController
  before_action :correct_user, only: :show
  before_action :logged_in_user

  def show
    @microposts = current_user.microposts.paginate(page: params[:page])
    @comment = current_user.comments.build if logged_in?
  end

  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.bookmark(micropost)
    micropost.create_bookmark_notification!(current_user)
    respond_to do |format|
      @micropost = Micropost.find(params[:micropost_id])
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  def destroy
    bookmark = Bookmark.find(params[:id])
    bookmark.destroy
    respond_to do |format|
      @micropost = Micropost.find_by(params[:micropost_id])
      format.html { redirect_to request.referrer || root_url }
      format.js
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


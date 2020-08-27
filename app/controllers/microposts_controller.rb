class MicropostsController < ApplicationController
before_action :logged_in_user, only: [:new, :show, :create, :search, :destroy]
before_action :correct_user,   only: :destroy

  def new
    @micropost  = current_user.microposts.build
  end

  def show
    @micropost = Micropost.find(params[:id])
    @comment = current_user.comments.build if logged_in?
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "投稿が完了しました。"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'microposts/new'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿が削除されました。"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end

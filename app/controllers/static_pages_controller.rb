class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: :search

  def home
    @feed_items = current_user.feed.paginate(page: params[:page]) if logged_in?
    @comment = current_user.comments.build if logged_in?
  end

  def search
    @comment = current_user.comments.build if logged_in?

    if params[:static_page][:search].present?
      microposts = Micropost.search(params[:static_page][:search]).paginate(page: params[:page])
      if microposts.any?
        @microposts = microposts
      else
        @microposts = Micropost.none.paginate(page: params[:page])
        @message = "条件に一致する投稿は見つかりませんでした"
      end
    else
      flash[:danger] = "検索ワードを入力してください"
      redirect_to request.referrer || root_url
    end
  end

end

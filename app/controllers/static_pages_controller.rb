class StaticPagesController < ApplicationController
  def home
    @feed_items = current_user.feed.paginate(page: params[:page]) if logged_in?
    @comment = current_user.comments.build if logged_in?
  end
end

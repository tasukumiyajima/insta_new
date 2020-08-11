class StaticPagesController < ApplicationController
  def home
      # @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page]) if logged_in?
  end
end

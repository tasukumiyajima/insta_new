class BookmarksController < ApplicationController
  before_action :logged_in_user

  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.bookmark(micropost)
    redirect_to request.referrer || root_url
  end

  def destroy
    bookmark = Bookmark.find(params[:id])
    bookmark.destroy
    redirect_to request.referrer || root_url
  end

end

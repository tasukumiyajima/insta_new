class BookmarksController < ApplicationController
  before_action :logged_in_user

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

end

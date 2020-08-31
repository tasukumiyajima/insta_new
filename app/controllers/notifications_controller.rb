class NotificationsController < ApplicationController
  before_action :logged_in_user

  def index
    @notifications = current_user.passive_notifications
    #通知画面を開くとcheckedをtrueにして通知確認済にする
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  def destroy
    @notifications =current_user.passive_notifications.destroy_all
    redirect_to notifications_path
  end
 
end

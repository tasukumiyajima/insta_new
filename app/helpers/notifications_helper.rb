module NotificationsHelper

  def notification_form(notification)
    @visitor = notification.visitor
    case notification.action
    when 'follow'
      tag.a(notification.visitor.name, href: user_path(@visitor)) + 'があなたをフォローしました'

    when 'bookmark'
      tag.a(notification.visitor.name, href: user_path(@visitor)) + 'が' + tag.a('あなたの投稿', 
      href: micropost_path(notification.micropost_id)) + 'をお気に入りに入れました'

    when 'comment' then
      tag.a(notification.visitor.name, href: user_path(@visitor)) + "が" + tag.a("あなたの投稿", 
      href: micropost_path(notification.micropost_id)) + "にコメントをしました"
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end

end

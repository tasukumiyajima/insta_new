module NotificationsHelper

  def notification_form(notification)
    #通知を送ってきたユーザーを取得
    @visitor = notification.visitor

    # notification.actionがfollowかbookmarkかcommentかで処理を変える
    case notification.action
    when 'follow'
      #aタグで通知を作成したユーザーshowのリンクを作成
      tag.a(notification.visitor.name, href: user_path(@visitor)) + 'があなたをフォローしました'

    when 'bookmark'
      tag.a(notification.visitor.name, href: user_path(@visitor)) + 'が' + tag.a('あなたの投稿', 
      href: "#") + 'をお気に入りに入れました'
      # micropost_path(notification.micropost_id)

    when 'comment' then
      tag.a(notification.visitor.name, href: user_path(@visitor)) + "が" + tag.a("あなたの投稿", 
      href: "#") + "にコメントをしました"
    end
  end

  # コメントがあった場合のコメントの内容を表示する
  # def notificated_comment_form(notification)
  #   @notified_comment = Comment.find_by(id: notification.comment_id) #if notification.comment_id.any?
  #   return @notified_comment.content
  # end

end

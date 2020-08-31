class Micropost < ApplicationRecord
  mount_uploader :picture, PictureUploader
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :picture, presence: true
  validate  :picture_size
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "画像のサイズを5MB未満にしてください")
    end
  end

  #ブックマークされたmicropostのユーザーへの通知を作成する
  def create_bookmark_notification!(visitor)
    #すでに通知が作成されているか確認
    temp = Notification.where(["visitor_id = ? and visited_id = ? and micropost_id = ? and action = ? ",
                                  visitor.id, user_id, id, 'bookmark'])
    if temp.blank?
      notification = visitor.active_notifications.new(
        visited_id: user_id,
        micropost_id: id,
        action: "bookmark"
        )
      if notification.visitor_id != notification.visited_id && notification.valid?
        notification.save
      end
    end
  end

  # コメントがあったmicropostのユーザーへの通知を作成する
  def create_comment_notification!(visitor, comment)
    #すでに通知が作成されているか確認
    temp = Notification.where(["visitor_id = ? and visited_id = ? and comment_id = ? and action = ? ",
                                    visitor.id, user_id, comment.id, 'comment'])
    if temp.blank?
      notification = visitor.active_notifications.new(
        visited_id: user_id,
        micropost_id: id,
        comment_id: comment.id,
        action: 'comment'
      )
      if notification.visitor_id != notification.visited_id && notification.valid?
        notification.save    
      end
    end
  end

  # 検索ワード(search)をcontentに含むmicropostを探す
  def self.search(search)
    Micropost.where(['content LIKE ?', "%#{search}%"]) if search
  end

end


class Micropost < ApplicationRecord

  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :picture, presence: true
  validate  :picture_size
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "画像のサイズを5MB未満にしてください")
    end
  end

end

class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  validates :image,   content_type: { in: %w[image/jpeg image/png],
                                      message: "有効な画像ファイルを使用してください。" },
                      size:         { less_than: 5.megabytes,
                                      message: "5MB以下の画像ファイルを使用してください。" }
                                      
  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(resize_to_limit: [300, 300])
  end

end

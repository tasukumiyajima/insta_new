class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :reset_token

  before_save :downcase_email, unless: :uid?
  validates :name, presence: true, length: { maximum: 50 }
  validates :user_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password validations: false
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true, on: :facebook_login

  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_microposts, through: :bookmarks, source: :micropost

  has_many :active_notifications, class_name: "Notification",
                                  foreign_key:"visitor_id",
                                  dependent: :destroy
  has_many :passive_notifications, class_name: "Notification",
                                   foreign_key:"visited_id", 
                                   dependent: :destroy
  validates :phone_number, numericality: { only_integer: true }, allow_blank: true,
                           length: { in: 9..12, message:"電話番号は数字のみ入力してください" }
  validates :sex, inclusion: { in: 1..2 }, allow_blank: true

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムな22文字の文字列(トークン)を返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # remember_tokenを発行して、データベースに関連するremember_digestを保存
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # tokenがデータベースのdigestと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # def update_new_password(new_password)
  #   update_attribute(:password_digest, User.digest(new_password))
  # end

  def authenticated_password?(password)
    BCrypt::Password.new(remember_digest).is_password?(password)
  end

  # データベースのremember_digestを破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # ユーザー自身(user_id)とフォロー中のユーザー(followings_ids)のMicropostsを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
              WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
              OR user_id = :user_id", user_id: id)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # micropostをブックマークする
  def bookmark(micropost)
    bookmarked_microposts << micropost
  end

  # ユーザーがmicropostをブックマークしていたらtrueを返す
  def bookmarked_microposts?(micropost)
    bookmarked_microposts.include?(micropost)
  end

  # パスワード再設定のtokenを発行して、digestをデータベースに保存
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する(メソッドはMailerで定義)
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def create_follow_notification!(visitor)
    #すでに通知が作成されているか確認
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",
                              visitor.id, id, 'follow'])
    if temp.blank?
      notification = visitor.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  def self.from_omniauth(auth)
    user = User.where('email = ?', auth.info.email).first
    if user.blank?
       user = User.new
    end
    user.uid   = auth.uid
    user.name  = auth.info.name
    user.user_name = auth.info.name
    user.email = auth.info.email
    user.oauth_token = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user
  end

  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

end

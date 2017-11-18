class User < ApplicationRecord
  attr_accessor :remember_token
  devise :omniauthable

  before_save { self.email = email.downcase } # データベースに保存するために全ての文字列を小文字に変換を行う
  # self.email.downcaseでも良かったが、右辺は省略可能

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password
  # password_digestという属性に保存可能になる
  # password、password_confirmationが使えるようになる
  # authenticateメソッドの定義

  validates :password, presence: true, length: { minimum: 6 }

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
   cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                   BCrypt::Engine.cost
   BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続化セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # omniauth認証
  def self.find_or_create_from_auth_hash(auth_hash)
    provider = auth_hash[:provider]
    uid = auth_hash[:uid]
    name = auth_hash[:info][:name]
    # image_url = auth_hash[:info][:image]

    User.find_or_create_by(provider: provider, uid: uid) do |user|
      user.name = name
      # user.image_url = image_url
    end
  end

  def self.find_for_oauth(auth)
    # authを確認することで値の取得を行っている
    user = User.where(uid: auth.uid, provider: auth.provider).first

    unless user
      user = User.create(
        uid:      auth.uid,
        provider: auth.provider,
        name: auth.info.name,
        email:    User.dummy_email(auth),
        password: Devise.friendly_token[0, 20]
      )
    end
    user
  end

    private
    def self.dummy_email(auth)
      "#{auth.uid}-#{auth.provider}@example.com"
    end

end

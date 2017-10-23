class User < ApplicationRecord
  before_save { self.email = email.downcase } # データベースに保存するために全ての文字列を小文字に変換を行う
  # self.email.downcaseでも良かったが、右辺は省略可能

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
end

class User < ApplicationRecord
  has_many :ratings, dependent: :destroy
  has_many :media, through: :ratings

  # BCrypt password login adapted from https://www.railstutorial.org
  attr_accessor :remember_token
  validates :username, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, if: :password

  class << self

    # Return the hash digest of a string
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Return a random token
    def new_token
      SecureRandom.urlsafe_base64
    end

  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # User authenticated if token matches digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forget a remembered user
  def forget
    update_attribute(:remember_digest, nil)
  end

end

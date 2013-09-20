class User < ActiveRecord::Base
  has_many :ratings
  has_many :queue_items, order: :position

  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true
  validates :password, presence: true, on: :create

end
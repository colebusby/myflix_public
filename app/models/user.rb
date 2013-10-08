class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, order: :position
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true
  validates :password, presence: true, on: :create

  before_create :generate_token

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def queue_items_count
    queue_items.count
  end

  def reviews_count
    reviews.count
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
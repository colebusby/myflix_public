class User < ActiveRecord::Base
  include Tokenable

  has_many :reviews
  has_many :queue_items, order: :position
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true
  validates :password, presence: true, on: :create

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

  def follows?(leader)
    relationship = Relationship.where(leader_id: leader.id, follower_id: self.id).first
    if relationship
      true
    else
      false
    end
  end

  def follow(leader)
    Relationship.create(leader: leader, follower: self)
  end

end
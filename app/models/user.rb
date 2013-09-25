class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, order: :position

  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true
  validates :password, presence: true, on: :create

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end
end
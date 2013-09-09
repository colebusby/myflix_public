class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :videos, through: :categorizations

  validates :name, presence: true, uniqueness: true

  def recently_added
    videos.order('created_at').reverse_order.limit(6)
  end
end
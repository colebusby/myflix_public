class Video < ActiveRecord::Base
  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :ratings

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_term)
    where("title like :search", search: "%#{search_term}%")
  end
end
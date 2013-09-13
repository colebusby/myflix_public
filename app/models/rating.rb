class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :video, dependent: :destroy

  validates :description, presence: true
  validates_uniqueness_of :user_id, scope: [ :video_id ]
end
class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  def video_title
    video.title
  end

  def rate
    rating = Rating.where(user_id: user.id, video_id: video.id).first
    if rating
      rating.rate
    else
      "Not Rated"
    end
  end

  def category_name
    video.categories.first.name
  end

  def category
    video.categories.first
  end
end
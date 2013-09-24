class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :position, numericality: {only_integer: true}

  def video_title
    video.title
  end

  def rate
    rating.rate if rating
  end

  def rate=(new_rate)
    if rating
      rating.update_column(:rate, new_rate)
    else
      new_rating = Rating.new(user: user, video: video, rate: new_rate)
      new_rating.save(validate: false)
    end
  end

  def category_name
    video.categories.first.name
  end

  def category
    video.categories.first
  end

  private

  def rating
    @rating ||= Rating.where(user_id: user.id, video_id: video.id).first
  end

end
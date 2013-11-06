class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    h.image_tag("/#{average_rating}")
  end

  private

  def average_rating
    if object.reviews.count == 0
      star_rating(0.0)
    else
      i = 0
      object.reviews.each { |review| i += review.rating }
      star_rating(round_point5(i / object.reviews.count))
    end
  end

  def star_rating(number)
    stars = {0.0 => "tmp/star0.png",1.0 => "tmp/star1.png", 1.5 => "tmp/star1half.png", 2.0 => "tmp/star2.png", 2.5 => "tmp/star2half.png", 3.0 => "tmp/star3.png", 3.5 => "tmp/star3half.png", 4.0 => "tmp/star4.png", 4.5 => "tmp/star4half.png", 5.0 => "tmp/star5.png"}
    stars[number]
  end

  def round_point5(number)
    (number * 2).round / 2.0
  end
end

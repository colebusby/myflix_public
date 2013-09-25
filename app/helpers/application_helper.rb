module ApplicationHelper
  def round_point5(number)
    (number * 2).round / 2.0
  end

  def star_rating(number)
    stars = {0.0 => "tmp/star0.png",1.0 => "tmp/star1.png", 1.5 => "tmp/star1half.png", 2.0 => "tmp/star2.png", 2.5 => "tmp/star2half.png", 3.0 => "tmp/star3.png", 3.5 => "tmp/star3half.png", 4.0 => "tmp/star4.png", 4.5 => "tmp/star4half.png", 5.0 => "tmp/star5.png"}
    stars[number]
  end

  def average_rating
    if @video.reviews.count == 0
      star_rating(0.0)
    else
      i = 0
      @video.reviews.each { |review| i += review.rating }
      star_rating(round_point5(i / @video.reviews.count))
    end
  end

  def options_for_video_ratings(selected=nil)
    options_for_select([ ['5 Stars', 5], ['4 Stars', 4], ['3 Stars', 3], ['2 Stars', 2], ['1 Star', 1], ['Not Rated', nil] ], selected)
  end

end

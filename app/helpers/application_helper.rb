module ApplicationHelper

  def options_for_video_ratings(selected=0)
    options_for_select([ ['Not Rated', 0], ['5 Stars', 5], ['4 Stars', 4], ['3 Stars', 3], ['2 Stars', 2], ['1 Star', 1] ], selected)
  end

  def avatar_url(user)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=mm"
  end

  def review_writer(review)
    reviewer = User.find(review.user_id)
    link_to "by #{reviewer.username}", user_path(reviewer.id)
  end

  def admin?
    !!current_user.admin
  end
end

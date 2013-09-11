class RatingsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @rating = Rating.new(params.require(:rating).permit(:description))
    @rating.video = @video
    @rating.user = current_user
  end
end
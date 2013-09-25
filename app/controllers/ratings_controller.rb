class RatingsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @rating = Rating.new(rating_params)
    @rating.video = @video
    @rating.user = current_user

    if @rating.save
      flash[:notice] = "Thank you for rating this video!"
      redirect_to video_path(@video.id)
    else
      @ratings = @video.ratings
      render 'videos/show'
    end
  end

  private

  def rating_params
    params.require(:rating).permit!
  end
end
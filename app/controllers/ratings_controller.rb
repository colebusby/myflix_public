class RatingsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @rating = Rating.new(params.require(:rating).permit(:description, :rate))
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
end
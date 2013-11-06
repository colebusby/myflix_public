class VideosController < ApplicationController
  before_action :require_user

  def index
    @videos = Video.all
  end

  def show
    @video = Video.find(params[:id]).decorate
    @review = Review.new
    @reviews = @video.reviews
    @user_review = Review.find_by(user_id: current_user.id, video_id: @video.id)
  end

  def search
    @results = Video.search_by_title(params[:search])
  end
end
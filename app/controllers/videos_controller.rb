class VideosController < ApplicationController
  before_action :require_user

  def index
    @videos = Video.all
  end

  def show
    @video = Video.find(params[:id])
    @rating = Rating.new
    @ratings = @video.ratings
    @user_rating = Rating.find_by(user_id: current_user.id, video_id: @video.id)
  end

  def search
    @results = Video.search_by_title(params[:search])
  end
end
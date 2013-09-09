class VideosController < ApplicationController

  def index
    if signed_in?
      @videos = Video.all
    else
      require_user
    end
  end

  def show
    @video = Video.find(params[:id])
  end

  def search
    @results = Video.search_by_title(params[:search])
  end

end
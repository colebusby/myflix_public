class Admin::VideosController < AdminController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "#{@video.title} successfully added."
      redirect_to new_admin_video_path
    else
      flash[:error] = "Please check that all entries are valid."
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit!
  end
end
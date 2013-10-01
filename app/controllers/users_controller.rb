class UsersController < ApplicationController
  before_action :require_user, only: [:show]

def new
  @user = User.new
end

def create
  @user = User.new(user_param)
  if @user.save
    flash[:notice] = "#{@user.username} is now registered with MyFlix!"
    session[:user_id] = @user.id
    redirect_to home_path
  else
    render :new
  end
end

def show
  @user = User.find(params[:id])
end

private

def user_param
  params.require(:user).permit!
end

end
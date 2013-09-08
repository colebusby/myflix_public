class UsersController < ApplicationController

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

private

def user_param
  params.require(:user).permit!
end

end
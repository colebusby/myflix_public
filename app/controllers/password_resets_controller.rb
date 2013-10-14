class PasswordResetsController < ApplicationController

  def show
    user = User.where(token: params[:id]).first
    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.where(token: params[:token]).first
    if user
      if params[:password].blank?
        flash[:error] = "Password cannot be blank."
        redirect_to password_reset_path(user.token)
      else
        user.password = params[:password]
        user.generate_token
        user.save
        flash[:success] = "Password successfully changed! Please sing in."
        redirect_to signin_path
      end
    else
      redirect_to expired_token_path
    end
  end
end
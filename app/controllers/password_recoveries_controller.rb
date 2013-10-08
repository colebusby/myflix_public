class PasswordRecoveriesController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      AppMailer.send_password_reset(user).deliver
      redirect_to password_recovery_confirmation_path
    else
      flash[:error] = "Email not found in system."
      redirect_to password_recovery_path
    end
  end

  def confirm
  end
end
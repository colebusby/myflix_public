class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :signed_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !!current_user
  end

  def require_user
    unless signed_in?
      flash[:info] = "Please sign in to access that feature."
      redirect_to signin_path
    end
  end

  def access_denied
    flash[:error] = "You cant do that!"
    redirect_to root_path
  end

  def active?
    current_user.active
  end

  def require_active
    unless active?
      flash[:error] = "Your account is not currently active."
      redirect_to user_payments_path(current_user)
    end
  end
end

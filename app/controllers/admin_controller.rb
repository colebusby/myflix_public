class AdminController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def require_admin
    unless current_user.admin
      flash[:error] = "You do not have access."
      redirect_to home_path
    end
  end
end
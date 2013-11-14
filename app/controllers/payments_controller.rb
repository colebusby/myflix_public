class PaymentsController < ApplicationController
  def index
    @user = User.find_by(params[:user])
    @payments = current_user.payments
  end
end
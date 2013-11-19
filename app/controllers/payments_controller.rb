class PaymentsController < ApplicationController
  before_action :require_user

  def index
    @user = User.find_by(params[:user])
    @payments = current_user.payments
  end

  def update_card
    user = User.find_by(params[:user])
    update = StripeWrapper::Customer.update(
      card:               params[:stripeToken],
      customer_token:     user.customer_token
    )
    if update.successful?
      user.update_attribute(:active, true)
      flash[:notice] = "Your card has been updated."
      redirect_to user_payments_path
    else
      flash[:error] = update.error_message
      redirect_to user_payments_path
    end
  end

  def cancel_subscription
    user = User.find_by(params[:user])
    StripeWrapper::Customer.cancel(user.customer_token)
    user.update_attribute(:active, false)
    flash[:notice] = "Your subscription has been canceled"
    redirect_to user_payments_path
  end
end
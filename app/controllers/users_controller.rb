class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_param)
    if @user.save
      handle_invitation
      charge_card
      WelcomeMailer.perform_async(@user.id)
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

  def new_with_invitation_token
    invitation = Invitation.find_by_token(params[:token])
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end



  private

  def user_param
    params.require(:user).permit!
  end

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.where(token: params[:invitation_token]).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.generate_token
    end
  end

  def charge_card
    # Amount in cents
    amount = 999
    token = params[:stripeToken]
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']

    charge = Stripe::Charge.create(
      card:        token,
      amount:      amount,
      currency:    'usd'
    )
  end
end
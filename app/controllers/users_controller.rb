class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_param)
    result = UserSignup.new(@user).signup(params[:stripeToken], params[:invitation_token])
    if result.successful?
      session[:user_id] = @user.id
      flash[:notice] = "#{@user.username} is now registered with MyFlix!"
      redirect_to home_path
    else
      flash[:error] = result.error_message
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
end
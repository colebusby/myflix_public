class UserSignup

  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def signup(stripe_token, invitation_token)
    if @user.valid?
      charge_card(stripe_token)
      if @customer_create.successful?
        @user.customer_token = @customer_create.customer_token
        @user.save
        handle_invitation(invitation_token)
        WelcomeMailer.perform_async(@user.id)
        @status = :success
        self
      else
        @status = :failed
        @error_message = @customer_create.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Email or password invalid."
      self
    end
  end

  def successful?
    @status == :success
  end

  private

  def charge_card(stripe_token)
    @customer_create = StripeWrapper::Customer.create(
      card:        stripe_token,
      email:       @user.email,
      description: "#{@user.username}'s enrollment charge."
    )
  end

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.where(token: invitation_token).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.generate_token
    end
  end
end
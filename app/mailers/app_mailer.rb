class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail(to: user.email, from: "info@myflix.com", subject: "Welcome to MyFlix!")
  end

  def send_password_reset(user)
    @user = user
    @token = user.token
    mail(to: user.email, from: "info@myflix.com", subject: "MyFlix account password reset link")
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    mail(to: invitation.recipient_email, from: "info@myflix.com", subject: "#{invitation.inviter.username} has sent you a MyFlix invite!")
  end
end
class WelcomeMailer
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    AppMailer.delay.send_welcome_email(user)
  end
end
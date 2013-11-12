class ChargeFailedMailer
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    AppMailer.delay.send_charge_failed_email(user)
  end
end
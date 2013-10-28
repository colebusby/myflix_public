module StripeWrapper
  class Charge
    def self.create(options = {})
      Stripe::Charge.create(
        amount: options[:amount],
        currency: 'usd',
        card: options[:card]
      )
    end
  end
end
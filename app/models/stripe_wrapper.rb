module StripeWrapper

  class Charge

      attr_reader :error_message, :response

      def initialize(options={})
        @response = options[:response]
        @error_message = options[:error_message]
      end

      def self.create(options = {})
        begin
          response = Stripe::Charge.create(
            amount: options[:amount],
            currency: 'usd',
            card: options[:card]
          )
          new(response: response)
        rescue Stripe::CardError => e
          new(error_message: e.message)
        end
      end

      def successful?
        response.present?
      end
    end

  class Customer

    attr_reader :error_message, :response

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          card: options[:card],
          plan: 'basic',
          email: options[:email],
          description: options[:description]
        )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def self.update(options={})
      begin
        customer = Stripe::Customer.retrieve(options[:customer_token])
        customer.card = options[:card]
        customer.update_subscription(:plan => "basic")
        response = customer.save
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def self.cancel(customer_token)
      customer = Stripe::Customer.retrieve(customer_token)
      customer.cancel_subscription
    end

    def successful?
      response.present?
    end

    def customer_token
      response.id
    end
  end
end
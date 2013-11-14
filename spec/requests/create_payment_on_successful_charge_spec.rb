require "spec_helper"

describe "create payment on successful charge" do
    let(:event_data) do
      {
      "id"=> "evt_102uSn2t3wtymrXO28L3e4wN",
      "created"=> 1384011735,
      "livemode"=> false,
      "type"=> "charge.succeeded",
      "data"=> {
        "object"=> {
          "id"=> "ch_102uSn2t3wtymrXOC8r1pOsp",
          "object"=> "charge",
          "created"=> 1384011735,
          "livemode"=> false,
          "paid"=> true,
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "card"=> {
            "id"=> "card_102uSn2t3wtymrXO3oZNoN4S",
            "object"=> "card",
            "last4"=> "4242",
            "type"=> "Visa",
            "exp_month"=> 11,
            "exp_year"=> 2016,
            "fingerprint"=> "1Gy1YHVI3TSu3P0L",
            "customer"=> "cus_2uSnmP0ajUr3C1",
            "country"=> "US",
            "name"=> nil,
            "address_line1"=> nil,
            "address_line2"=> nil,
            "address_city"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_country"=> nil,
            "cvc_check"=> "pass",
            "address_line1_check"=> nil,
            "address_zip_check"=> nil
          },
          "captured"=> true,
          "refunds"=> [],
          "balance_transaction"=> "txn_102uSn2t3wtymrXO7RvEUXxv",
          "failure_message"=> nil,
          "failure_code"=> nil,
          "amount_refunded"=> 0,
          "customer"=> "cus_2uSnmP0ajUr3C1",
          "invoice"=> "in_102uSn2t3wtymrXOhJwJ10d1",
          "description"=> nil,
          "dispute"=> nil,
          "metadata"=> {}
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_2uSnKexyQdl2bD"
      }
    end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    lisa = Fabricate(:user, customer_token: "cus_2uSnmP0ajUr3C1")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(lisa)
  end

  it "creates the payment with the amount", :vcr do
    lisa = Fabricate(:user, customer_token: "cus_2uSnmP0ajUr3C1")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do
    lisa = Fabricate(:user, customer_token: "cus_2uSnmP0ajUr3C1")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_102uSn2t3wtymrXOC8r1pOsp")
  end
end
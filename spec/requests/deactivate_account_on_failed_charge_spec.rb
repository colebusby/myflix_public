require "spec_helper"

describe "deactivate account on failed charge" do
  let(:event_data) do
    {
      "id"=> "evt_102vIH2t3wtymrXOkrP6ZGNV",
      "created"=> 1384203225,
      "livemode"=> false,
      "type"=> "charge.failed",
      "data"=> {
        "object"=> {
          "id"=> "ch_102vIH2t3wtymrXOtzyR2rMK",
          "object"=> "charge",
          "created"=> 1384203225,
          "livemode"=> false,
          "paid"=> false,
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "card"=> {
            "id"=> "card_102vGp2t3wtymrXOt6QDxndB",
            "object"=> "card",
            "last4"=> "0341",
            "type"=> "Visa",
            "exp_month"=> 11,
            "exp_year"=> 2018,
            "fingerprint"=> "Tzop2rUcqpxvGllN",
            "customer"=> "cus_2vFaHQa93CrN7s",
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
          "captured"=> false,
          "refunds"=> [],
          "balance_transaction"=> nil,
          "failure_message"=> "Your card was declined.",
          "failure_code"=> "card_declined",
          "amount_refunded"=> 0,
          "customer"=> "cus_2vFaHQa93CrN7s",
          "invoice"=> nil,
          "description"=> "another fail test",
          "dispute"=> nil,
          "metadata"=> {}
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_2vIHLYWrH2VhXL"
    }
  end

  it "sets user.active to false", :vcr do
    lisa = Fabricate(:user, customer_token: "cus_2vFaHQa93CrN7s")
    post "/stripe_events", event_data
    expect(lisa.reload).not_to be_active
  end
end
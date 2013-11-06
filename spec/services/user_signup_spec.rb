require 'spec_helper'

describe UserSignup do
  describe "#signup" do
    context "valid personal info and valid card" do
      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end
      after { ActionMailer::Base.deliveries.clear }

      it "creates user" do
        UserSignup.new(Fabricate.build(:user)).signup("stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "makes the user follow the inviter" do
        lisa = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: lisa, recipient_email: 'alice@example.com')
        UserSignup.new(User.create(username: 'Alice', email: 'alice@example.com', password: 'password')).signup("stripe_token", invitation.token)
        alice = User.where(email: 'alice@example.com').first
        expect(alice.follows?(lisa)).to be_true
      end

      it "makes the inviter follow the user" do
        lisa = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: lisa, recipient_email: 'alice@example.com')
        UserSignup.new(User.create(username: 'Alice', email: 'alice@example.com', password: 'password')).signup("stripe_token", invitation.token)
        alice = User.where(email: 'alice@example.com').first
        expect(lisa.follows?(alice)).to be_true
      end

      it "expires the invitation upon registration" do
        lisa = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: lisa, recipient_email: 'alice@example.com', token: '12345')
        UserSignup.new(User.create(username: 'Alice', email: 'alice@example.com', password: 'password')).signup("stripe_token", invitation.token)
        alice = User.where(email: 'alice@example.com').first
        expect(invitation.token).to_not eq('12345')
      end

      it "sends out email to the user with valid inputs" do
        UserSignup.new(User.create(username: 'Alice', email: 'alice@example.com', password: 'password')).signup("stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["alice@example.com"])
      end

      it "send out email containing the user's name with valid inputs" do
        UserSignup.new(User.create(username: 'Alice', email: 'alice@example.com', password: 'password')).signup("stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("Alice")
      end
    end

    context "with valid user and with declined card" do

      it "does not create a new user record" do
        charge = double(charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.stub(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user)).signup("stripe_token", nil)
        expect(User.count).to eq(0)
      end
    end

    context "without valid user info" do
      before do
        UserSignup.new(User.new(email: '123@gmail.com', username: Faker::Name.name)).signup("stripe_token", nil)
      end

      it "does not save @user" do
        expect(User.count).to eq(0)
      end

      it "does not charge card" do
        StripeWrapper::Charge.should_not_receive(:create)
      end

      it "does not send email with invalid inputs" do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end
end
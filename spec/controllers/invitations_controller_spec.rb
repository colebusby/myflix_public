require 'spec_helper'

describe InvitationsController do
  describe "GET new" do

    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do

    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    context "with valid inputs" do

      after { ActionMailer::Base.deliveries.clear }

      it "redirects to new invitation page" do
        set_current_user
        post :create, invitation: { recipient_name: "Alice", recipient_email: "alice@example.com", message: "Join MyFlix NOW!!!" }
        expect(response).to redirect_to new_invitation_path
      end

      it "creates new invitation" do
        set_current_user
        post :create, invitation: { recipient_name: "Alice", recipient_email: "alice@example.com", message: "Join MyFlix NOW!!!" }
        expect(Invitation.count).to eq(1)
      end

      it "sends email to recipient" do
        set_current_user
        post :create, invitation: { recipient_name: "Alice", recipient_email: "alice@example.com", message: "Join MyFlix NOW!!!" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['alice@example.com'])
      end

      it "sets the flash sucess message" do
        set_current_user
        post :create, invitation: { recipient_name: "Alice", recipient_email: "alice@example.com", message: "Join MyFlix NOW!!!" }
        expect(flash[:success]).to eq("An email has been sent to Alice. Who else would you like to invite to MyFlix?")
      end
    end
    context "with invalid inputs" do

      it "renders the new template" do
        set_current_user
        post :create, invitation: { recipient_email: "alice@example.com", message: "Join MyFlix NOW!!!" }
        expect(response).to render_template :new
      end

      it "does not create an invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "alice@example.com", message: "Join MyFlix NOW!!!" }
        expect(Invitation.count).to eq(0)
      end

      it "does not send out an email" do
        set_current_user
        post :create, invitation: { recipient_email: "alice@example.com", message: "Join MyFlix NOW!!!" }
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

      it "sets the flash error message" do
        set_current_user
        post :create, invitation: { recipient_email: "alice@example.com", message: "Join MyFlix NOW!!!" }
        expect(flash[:error]).to eq("Please make sure all fields are filled.")
      end

      it "sets @invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "alice@example.com", message: "Join MyFlix NOW!!!" }
        expect(assigns(:invitation)).to be_present
      end
    end
  end
end
require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets user as new blank User" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do

    context "successful user signup" do

      it "redirects to home path" do
        result = double(:signup_reslut, successful?: true)
        UserSignup.any_instance.should_receive(:signup).and_return(result)
        post :create, user: Fabricate.to_params(:user)
        expect(response).to redirect_to home_path
      end
    end

    context "failed user signup" do

      it "renders the new template" do
        result = double(:signup_reslut, successful?: false, error_message: 'Your card was declined')
        UserSignup.any_instance.should_receive(:signup).and_return(result)
        post :create, user: Fabricate.to_params(:user), stripeToken: '12345'
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        result = double(:signup_reslut, successful?: false, error_message: 'Your card was declined')
        UserSignup.any_instance.should_receive(:signup).and_return(result)
        post :create, user: Fabricate.to_params(:user), stripeToken: '12345'
        expect(flash[:error]).to be_present
      end
    end
  end

  describe "GET show" do
    context "with authenticated user" do

      before { set_current_user }

      it "renders show page of selected user" do
        lisa = current_user
        get :show, id: lisa.id
        expect(response).to render_template :show
      end

      it "sets @user to selected user when selected is current user" do
        lisa = current_user
        get :show, id: lisa.id
        expect(assigns(:user)).to eq(lisa)
      end

      it "sets @user to selected user when selected is not current user" do
        lisa = current_user
        alice = Fabricate(:user)
        get :show, id: alice.id
        expect(assigns(:user)).to eq(alice)
      end
    end
    context "without authenticated user" do

      it "should redirect to sign in page" do
        alice = Fabricate(:user)
        get :show, id: alice.id
        expect(response).to redirect_to signin_path
      end
    end
  end

  describe "GET new_with_invitation_token" do

    it "renders register(new) page" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "assigns user email with recipients email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "redirects to expired token page for invalid tokens" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end
end
require 'spec_helper'

describe PasswordResetsController do
  describe 'GET show' do

    it "renders show page if the token is valid" do
      lisa = Fabricate(:user)
      lisa.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end

    it "sets token" do
      lisa = Fabricate(:user)
      lisa.update_column(:token, '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end
  end

  describe 'POST create' do
    context 'with blank input' do

      it "redirects to password reset page" do
        lisa = Fabricate(:user)
        post :create, password: '', token: lisa.token
        expect(response).to redirect_to password_reset_path(lisa.token)
      end

      it "shows error message" do
        lisa = Fabricate(:user)
        post :create, password: '', token: lisa.token
        expect(flash[:error]).to eq("Password cannot be blank.")
      end
    end

    context "with valid token" do
      it "redirects to sign in page" do
        lisa = Fabricate(:user, password: 'old_password')
        post :create, token: lisa.token, password: 'new_password'
        expect(response).to redirect_to signin_path
      end

      it "updates the user's password" do
        lisa = Fabricate(:user, password: 'old_password')
        post :create, token: lisa.token, password: 'new_password'
        expect(lisa.reload.authenticate('new_password')).to be_true
      end

      it "shows success message" do
        lisa = Fabricate(:user, password: 'old_password')
        post :create, token: lisa.token, password: 'new_password'
        expect(flash[:success]).to eq("Password successfully changed! Please sing in.")
      end

      it "resets user token" do
        lisa = Fabricate(:user, password: 'old_password')
        lisa.update_column(:token, '12345')
        post :create, token: lisa.token, password: 'new_password'
        expect(lisa.reload.token).not_to eq('12345')
      end
    end

    context "with invalid token" do
      it "redirects to expired token page" do
        post :create, token: '12346', password: 'new_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
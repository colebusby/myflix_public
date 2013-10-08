require 'spec_helper'

describe PasswordRecoveriesController do
  describe 'POST create' do

    context 'with blank input' do

      it 'redirects to password recovery page' do
        post :create, email: ''
        expect(response).to redirect_to password_recovery_path
      end

      it 'show error message' do
        post :create, email: ''
        expect(flash[:error]).to eq("Email not found in system.")
      end
    end

    context 'with valid email' do

      it 'redirect to sent email page' do
        lisa = Fabricate(:user)
        post :create, email: lisa.email
        expect(response).to redirect_to password_recovery_confirmation_path
      end

      it 'sends email with password reset link' do
        lisa = Fabricate(:user)
        post :create, email: lisa.email
        expect(ActionMailer::Base.deliveries.last.to).to eq([lisa.email])
      end
    end

    context 'with invalid email' do

      it 'redirects to password recovery page' do
        post :create, email: 'something@notvalid.com'
        expect(response).to redirect_to password_recovery_path
      end

      it 'show error message' do
        post :create, email: 'something@notvalid.com'
        expect(flash[:error]).to eq("Email not found in system.")
      end
    end
  end
end
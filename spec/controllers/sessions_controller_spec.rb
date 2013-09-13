require 'spec_helper'

describe SessionsController do
  describe 'GET index' do

    it "renders index for unauthenticated users" do
      get :index
      expect(response).to render_template :index
    end

    it "redirects to home_path for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :index
      expect(response).to redirect_to home_path
    end
  end

  describe 'POST create' do
    context "user sign in validates" do

      before do
        @lisa = Fabricate(:user)
        post :create, email: @lisa.email, password: @lisa.password
      end

      it "sets session to user.id" do
        expect(session[:user_id]).to eq(@lisa.id)
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end
    end

    context "user sign in does not validate" do

      before do
        @lisa = Fabricate(:user)
        post :create, password: @lisa.password
      end

      it "renders the new template" do
        expect(response).to redirect_to signin_path
      end

      it "sets the error" do
        expect(flash[:error]).not_to be_blank
      end
    end
  end

  describe 'GET destroy' do

    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it "sets session user id to nil" do
      expect(session[:user_id]).to eq(nil)
    end

    it "sets the notice" do
      expect(flash[:notice]).not_to be_blank
    end

    it "redirects to root path" do
      expect(response).to redirect_to root_path
    end
  end
end
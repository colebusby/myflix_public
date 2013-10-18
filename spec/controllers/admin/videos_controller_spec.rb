require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    context "with authenticated admin" do

      it "renders admin video page" do
        session[:user_id] = Fabricate(:user, admin: true).id
        get :new
        expect(response).to render_template :new
      end

    end
    context "with authenticated user that is not an admin" do

      it "redirects to user video page" do
        session[:user_id] = Fabricate(:user)
        get :new
        expect(response).to redirect_to home_path
      end

      it "sets error message" do
        session[:user_id] = Fabricate(:user)
        get :new
        expect(flash[:error]).to eq("You do not have access.")
      end
    end
    context "with unauthenticated user" do

      it "redirects to user sign in" do
        get :new
        expect(response).to redirect_to signin_path
      end

      it "sets info message" do
        get :new
        expect(flash[:info]).to have_content
      end
    end
  end
end
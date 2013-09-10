require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "redirects users to signin page for unathenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to signin_path
    end
  end

  describe "POST search" do
    it "sets @results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      serenity = Fabricate(:video, title: 'Serenity')
      post :search, search: 'nity'
      expect(assigns(:results)).to eq([serenity])
    end
    it "redirects users to signin page for unathenticated users" do
      serenity = Fabricate(:video, title: 'Serenity')
      post :search, search: 'nity'
      expect(response).to redirect_to signin_path
    end
  end
end
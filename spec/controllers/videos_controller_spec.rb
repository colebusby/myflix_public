require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "for authenticated users" do
      before do
        session[:user_id] = Fabricate(:user).id
        @video = Fabricate(:video)
        @rating1 = Fabricate(:rating, video_id: @video.id)
        @rating2 = Fabricate(:rating, video_id: @video.id)
        get :show, id: @video.id
      end

      it "sets @video" do
        expect(assigns(:video)).to eq(@video)
      end

      it "sets @rating to new instance" do
        expect(assigns(:rating)).to be_instance_of(Rating)
      end

      it "sets @ratings" do
        expect(assigns(:ratings)).to match_array [@rating1, @rating2]
      end
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
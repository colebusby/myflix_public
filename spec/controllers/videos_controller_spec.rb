require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "for authenticated users" do

      let(:video) { Fabricate(:video) }
      let(:lisa) { Fabricate(:user) }
      let(:review1) { Fabricate(:review, video: video, user: lisa) }
      let(:review2) { Fabricate(:review, video: video) }

      before do
        session[:user_id] = lisa.id
        get :show, id: video.id
      end

      it "sets @video" do
        expect(assigns(:video)).to eq(video)
      end

      it "sets @review to new instance" do
        expect(assigns(:review)).to be_instance_of(Review)
      end

      it "sets @reviews" do
        expect(assigns(:reviews)).to match_array [review1, review2]
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

      it_behaves_like "require_sign_in" do
        let(:action) { post :search }
      end
  end
end
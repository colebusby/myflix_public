require 'spec_helper'

describe RatingsController do
  describe "POST create" do
    context "with authenticated users" do
      context "with valid input" do
        before do
          session[:user_id] = Fabricate(:user).id
          @video = Fabricate(:video)
          post :create, rating: Fabricate.attributes_for(:rating), video_id: @video.id, user_id: session[:user_id]
        end

        it "creates a rating" do
          expect(Rating.count).to eq(1)
        end

        it "creates a rating associated with video" do
          expect(Rating.first.video).to eq(@video)
        end

        it "creates a rating associated with current user" do
          expect(Rating.first.user).to eq(User.find(session[:user_id]))
        end

        it "redirects to video show page" do
          expect(response).to redirect_to @video
        end
      end
      context "with invalid input" do
        before do
          session[:user_id] = Fabricate(:user).id
          @video = Fabricate(:video)
          @rating = Fabricate(:rating, video_id: @video.id)
          post :create, rating: {rate: 1}, video_id: @video.id, user_id: session[:user_id]
        end

        it "does not create a rating" do
          expect(Rating.count).to eq(1)
        end

        it "renders video show page" do
          expect(response).to render_template 'videos/show'
        end

        it "sets @video" do
          expect(assigns(:video)).to eq(@video)
        end

        it "sets @ratings" do
          expect(assigns(:ratings)).to match_array([@rating])
        end
      end
    end
    context "with unathenticated users" do
      it "redirects to sign in path" do
        @video = Fabricate(:video)
        post :create, rating: Fabricate.attributes_for(:rating), video_id: @video.id
        expect(response).to redirect_to signin_path
      end
    end
  end
end
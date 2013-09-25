require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "with authenticated users" do
      context "with valid input" do

        let(:video) { Fabricate(:video) }

        before do
          session[:user_id] = Fabricate(:user).id
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id, user_id: session[:user_id]
        end

        it "creates a review" do
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with video" do
          expect(Review.first.video).to eq(video)
        end

        it "creates a review associated with current user" do
          expect(Review.first.user).to eq(User.find(session[:user_id]))
        end

        it "redirects to video show page" do
          expect(response).to redirect_to video
        end
      end
      context "with invalid input" do

        let(:video) { Fabricate(:video) }
        let(:review) { Fabricate(:review, video: video) }

        before do
          session[:user_id] = Fabricate(:user).id
          post :create, review: {rating: 1}, video_id: video.id, user_id: session[:user_id]
        end

        it "does not create a review" do
          expect(Review.count).to eq(0)
        end

        it "renders video show page" do
          expect(response).to render_template 'videos/show'
        end

        it "sets @video" do
          expect(assigns(:video)).to eq(video)
        end

        it "sets @reviews" do
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end
    context "with unathenticated users" do
      it "redirects to sign in path" do
        video = Fabricate(:video)
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to signin_path
      end
    end
  end
end
require 'spec_helper'

describe Admin::VideosController do

  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it_behaves_like "require_admin" do
      let(:action) { get :new }
    end

    it "renders admin video page" do
      session[:user_id] = Fabricate(:user, admin: true).id
      get :new
      expect(response).to render_template :new
    end

    it "sets @video to new video" do
      session[:user_id] = Fabricate(:user, admin: true).id
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    it_behaves_like "require_admin" do
      let(:action) { post :create }
    end

    context "with valid input" do

      it "redirects to new video page" do
        session[:user_id] = Fabricate(:user, admin: true).id
        cartoon = Fabricate(:category, name: "Cartoon")
        post :create, video: {title: "Simpsons", category_ids: ["1"], description: "old cartoon"}
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates new video" do
        session[:user_id] = Fabricate(:user, admin: true).id
        cartoon = Fabricate(:category, name: "Cartoon")
        post :create, video: {title: "Simpsons", category_ids: ["1"], description: "old cartoon"}
        expect(cartoon.videos.count).to eq(1)
      end

      it "sets success flash message" do
        session[:user_id] = Fabricate(:user, admin: true).id
        cartoon = Fabricate(:category, name: "Cartoon")
        post :create, video: {title: "Simpsons", category_ids: ["1"], description: "old cartoon"}
        expect(flash[:success]).to eq("Simpsons successfully added.")
      end

    end

    context "with invalid input" do

      it "does not create a video" do
        session[:user_id] = Fabricate(:user, admin: true).id
        cartoon = Fabricate(:category, name: "Cartoon")
        post :create, video: {category_ids: ["1"], description: "old cartoon"}
        expect(cartoon.videos.count).to eq(0)
      end

      it "renders the new template" do
        session[:user_id] = Fabricate(:user, admin: true).id
        cartoon = Fabricate(:category, name: "Cartoon")
        post :create, video: {category_ids: ["1"], description: "old cartoon"}
        expect(response).to render_template :new
      end

      it "sets the @video variable" do
        session[:user_id] = Fabricate(:user, admin: true).id
        cartoon = Fabricate(:category, name: "Cartoon")
        post :create, video: {category_ids: ["1"], description: "old cartoon"}
        expect(assigns(:video)).to be_present
      end

      it "sets the flash error message" do
        session[:user_id] = Fabricate(:user, admin: true).id
        cartoon = Fabricate(:category, name: "Cartoon")
        post :create, video: {category_ids: ["1"], description: "old cartoon"}
        expect(flash[:error]).to be_present
      end
    end
  end
end
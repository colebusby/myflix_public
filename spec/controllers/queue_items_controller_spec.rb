require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do

    it "sets @queue_item to the queue items of the logged in user" do
      lisa = Fabricate(:user)
      session[:user_id] = lisa.id
      queue_item1 = Fabricate(:queue_item, user: lisa)
      queue_item2 = Fabricate(:queue_item, user: lisa)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to signin_path
    end

  end

  describe "POST create" do

    it "creates new queue_item" do
      session[:user_id] = Fabricate(:user)
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "associates @video with new queue item" do
      session[:user_id] = Fabricate(:user)
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "associates current user with new queue item" do
      lisa = Fabricate(:user)
      session[:user_id] = lisa
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(lisa)
    end

    it "redirects to my queue" do
      session[:user_id] = Fabricate(:user)
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "puts video at end of queue list" do
      lisa = Fabricate(:user)
      session[:user_id] = lisa
      movie1 = Fabricate(:video)
      Fabricate(:queue_item, video: movie1, user: lisa)
      movie2 = Fabricate(:video)
      post :create, video_id: movie2.id
      movie2_queue_item = QueueItem.where(video_id: movie2.id, user_id: lisa.id).first
      expect(movie2_queue_item.position).to eq(2)
    end

    it "does not add video to queue if video is already in queue" do
      lisa = Fabricate(:user)
      session[:user_id] = lisa
      movie1 = Fabricate(:video)
      Fabricate(:queue_item, video: movie1, user: lisa)
      post :create, video_id: movie1.id
      expect(lisa.queue_items.count).to eq(1)
    end
    it "redirects to sign in for unauthenticated users" do
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to signin_path
    end
  end
end
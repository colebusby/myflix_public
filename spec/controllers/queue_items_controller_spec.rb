require 'spec_helper'
require 'pry'

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
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "associates @video with new queue item" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "associates current user with new queue item" do
      lisa = Fabricate(:user)
      session[:user_id] = lisa.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(lisa)
    end

    it "redirects to my queue" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "puts video at end of queue list" do
      lisa = Fabricate(:user)
      session[:user_id] = lisa.id
      movie1 = Fabricate(:video)
      Fabricate(:queue_item, video: movie1, user: lisa)
      movie2 = Fabricate(:video)
      post :create, video_id: movie2.id
      movie2_queue_item = QueueItem.where(video_id: movie2.id, user_id: lisa.id).first
      expect(movie2_queue_item.position).to eq(2)
    end

    it "does not add video to queue if video is already in queue" do
      lisa = Fabricate(:user)
      session[:user_id] = lisa.id
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

  describe "DELETE destroy" do
    it "deletes queue item for authenticated user" do
      lisa = Fabricate(:user)
      session[:user_id] = lisa.id
      queue_item = Fabricate(:queue_item, user: lisa)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "redirects to my queue path" do
      lisa = Fabricate(:user)
      session[:user_id] = lisa.id
      queue_item = Fabricate(:queue_item, user: lisa)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "does not delete queue items that belongs to other users" do
      lisa = Fabricate(:user)
      alice = Fabricate(:user)
      queue_item1 = Fabricate(:queue_item, user: lisa)
      queue_item2 = Fabricate(:queue_item, user: alice)
      session[:user_id] = lisa.id
      delete :destroy, id: queue_item2.id
      expect(QueueItem.count).to eq(2)
    end

    it "redirects to sign in path for unauthenticated user" do
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to signin_path
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
      it "redirect_to my queue" do
        lisa = Fabricate(:user)
        session[:user_id] = lisa.id
        queue_item1 = Fabricate(:queue_item, user: lisa, position: 1)
        queue_item2 = Fabricate(:queue_item, user: lisa, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        lisa = Fabricate(:user)
        session[:user_id] = lisa.id
        queue_item1 = Fabricate(:queue_item, user: lisa, position: 1)
        queue_item2 = Fabricate(:queue_item, user: lisa, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(lisa.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the queue item position" do
        lisa = Fabricate(:user)
        session[:user_id] = lisa.id
        queue_item1 = Fabricate(:queue_item, user: lisa, position: 1)
        queue_item2 = Fabricate(:queue_item, user: lisa, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(lisa.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid inputs" do

      it "makes no changes if the same number is input more than once" do
        lisa = Fabricate(:user)
        session[:user_id] = lisa.id
        queue_item1 = Fabricate(:queue_item, user: lisa, position: 1)
        queue_item2 = Fabricate(:queue_item, user: lisa, position: 2)
        queue_item3 = Fabricate(:queue_item, user: lisa, position: 3)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 3}, {id: queue_item3.id, position: 1}]
        expect(lisa.queue_items).to eq([queue_item1, queue_item2, queue_item3])
      end

      it "makes no changes if non-integer is entered" do
        lisa = Fabricate(:user)
        session[:user_id] = lisa.id
        queue_item1 = Fabricate(:queue_item, user: lisa, position: 1)
        queue_item2 = Fabricate(:queue_item, user: lisa, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: "d"}]
        expect(lisa.queue_items).to eq([queue_item1, queue_item2])
      end
    end

    context "with unauthenticated user"
    context "with other user's queue"
  end
end
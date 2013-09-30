require 'spec_helper'
require 'pry'

describe QueueItemsController do

  before { set_current_user }

  describe "GET index" do

    it "sets @queue_item to the queue items of the logged in user" do
      lisa = current_user
      queue_item1 = Fabricate(:queue_item, user: lisa)
      queue_item2 = Fabricate(:queue_item, user: lisa)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

      it_behaves_like "require_sign_in" do
        let(:action) { get :index }
      end

  end

  describe "POST create" do

    it "creates new queue_item" do
      post_create_queue_item_with_video
      expect(QueueItem.count).to eq(1)
    end

    it "associates video with new queue item" do
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "associates current user with new queue item" do
      lisa = current_user
      post_create_queue_item_with_video
      expect(QueueItem.first.user).to eq(lisa)
    end

    it "redirects to my queue" do
      post_create_queue_item_with_video
      expect(response).to redirect_to my_queue_path
    end

    it "puts video at end of queue list" do
      lisa = current_user
      movie1 = Fabricate(:video)
      Fabricate(:queue_item, video: movie1, user: lisa)
      movie2 = Fabricate(:video)
      post :create, video_id: movie2.id
      movie2_queue_item = QueueItem.where(video_id: movie2.id, user_id: lisa.id).first
      expect(movie2_queue_item.position).to eq(2)
    end

    it "does not add video to queue if video is already in queue" do
      lisa = current_user
      movie1 = Fabricate(:video)
      Fabricate(:queue_item, video: movie1, user: lisa)
      post :create, video_id: movie1.id
      expect(lisa.queue_items.count).to eq(1)
    end

      it_behaves_like "require_sign_in" do
        let(:action) { post :create }
      end
  end

  describe "DELETE destroy" do
    it "deletes queue item for authenticated user" do
      lisa = current_user
      queue_item = Fabricate(:queue_item, user: lisa)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "redirects to my queue path" do
      lisa = current_user
      queue_item = Fabricate(:queue_item, user: lisa)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "does not delete queue items that belongs to other users" do
      lisa = current_user
      alice = Fabricate(:user)
      queue_item1 = Fabricate(:queue_item, user: lisa)
      queue_item2 = Fabricate(:queue_item, user: alice)
      delete :destroy, id: queue_item2.id
      expect(QueueItem.count).to eq(2)
    end

    it "redirects to sign in path for unauthenticated user" do
      clear_current_user
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to signin_path
    end
  end

  describe "POST update_queue" do

    context "with valid inputs" do

      it "redirect_to my queue" do
        lisa = current_user
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: lisa, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: lisa, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        lisa = current_user
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: lisa, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: lisa, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(lisa.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the queue item position" do
        lisa = current_user
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: lisa, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: lisa, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 1}]
        expect(lisa.queue_items.last.position).to eq(2)
      end

    end

    context "with invalid inputs" do

      it "redirects to my queue page" do
        lisa = current_user
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: lisa, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: lisa, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.5}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the fash error message" do
        lisa = current_user
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: lisa, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: lisa, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.5}, {id: queue_item2.id, position: 1}]
        expect(flash[:error]).to be_present
      end

      it "does not change the queue items" do
        lisa = current_user
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: lisa, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: lisa, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(lisa.queue_items.first.position).to eq(1)
      end
    end

    context "with unauthenticated user" do

      it_behaves_like "require_sign_in" do
        let(:action) { post :update_queue }
      end
    end

    context "with other user's queue" do

      it "makes no changes to current user's queue" do
        lisa = current_user
        alice = Fabricate(:user)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: lisa, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end

    end
  end
end
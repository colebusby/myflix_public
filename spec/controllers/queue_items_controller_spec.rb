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
end
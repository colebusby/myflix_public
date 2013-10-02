require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do

    it "sets @relationships to the current user's following relationships" do
      set_current_user
      lisa = current_user
      alice = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: lisa, leader: alice)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do

    it_behaves_like "require_sign_in" do
      let(:action) { get :destroy, id: 4 }
    end
    it "deletes the relationship if the current user is the follower" do
      set_current_user
      lisa = current_user
      alice = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: lisa, leader: alice)
      delete :destroy, id: relationship.id
      expect(lisa.following_relationships.count).to eq(0)
    end
    it "redirects to the people page" do
      set_current_user
      lisa = current_user
      alice = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: lisa, leader: alice)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end
    it "does not delete the relationship if the current user is not the follower" do
      set_current_user
      lisa = current_user
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: alice)
      delete :destroy, id: relationship.id
      expect(bob.following_relationships.count).to eq(1)
    end
  end

  describe "POST create" do
    it "redirects to selected user's show page" do
      set_current_user
      lisa = current_user
      alice = Fabricate(:user)
      post :create, leader_id: alice.id
      expect(response).to redirect_to user_path(alice.id)
    end

    it "creates relationship where current user is follower and selected user is leader" do
      set_current_user
      lisa = current_user
      alice = Fabricate(:user)
      post :create, leader_id: alice.id
      expect(lisa.following_relationships.count).to eq(1)
    end
    it "does not create relationship is current user already follows selected user" do
      set_current_user
      lisa = current_user
      alice = Fabricate(:user)
      Fabricate(:relationship, leader_id: alice.id, follower_id: lisa.id)
      post :create, leader_id: alice.id
      expect(lisa.following_relationships.count).to eq(1)
    end
    it "does not allow user to follow themselves" do
      set_current_user
      lisa = current_user
      post :create, leader_id: lisa.id
      expect(lisa.following_relationships.count).to eq(0)
    end
  end
end
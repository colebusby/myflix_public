class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end

  def create
    leader = User.find(params[:leader_id])
    relationship = Relationship.new(leader_id: leader.id, follower_id: current_user.id)
    if leader != current_user && relationship.save
      flash[:notice] = "You are now following #{leader.username}"
      redirect_to user_path(params[:leader_id])
    else
      render "/users/show"
    end
  end
end
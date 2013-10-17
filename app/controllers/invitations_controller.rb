class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_param)
    if @invitation.save
      InviteMailer.perform_async(@invitation.id)
      flash[:success] = "An email has been sent to #{@invitation.recipient_name}. Who else would you like to invite to MyFlix?"
      redirect_to new_invitation_path
    else
      flash[:error] = "Please make sure all fields are filled."
      render :new
    end
  end

  private
  def invitation_param
    params.require(:invitation).permit!.merge(inviter_id: current_user.id)
  end
end
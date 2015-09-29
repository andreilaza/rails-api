class Api::V1::InvitationsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def create
    invitation = Invitation.new(invitation_params)
    
    invitation.invitation = SecureRandom.hex(30)
    invitation.expires = DateTime.now + 2.days

    invitation.sent = 1
    # email sending
    InvitationsMailer.send_invitation(invitation_params[:email], invitation).deliver
        
    if invitation.save
      render json: invitation, status: 201, root: false
    else
      render json: { errors: invitation.errors }, status: 422
    end
  end

  def check
    invitation = Invitation.find_by(invitation: params[:invitation])
    if invitation.expires > DateTime.now
      render json: {"success" => "Invitation is valid"}, status: 200, root: false
    else
      render json: {"error" => "Invitation is invalid"}, status: 422, root: false
    end
    
  end

  private
    def invitation_params
      params.permit(:email)
    end

end

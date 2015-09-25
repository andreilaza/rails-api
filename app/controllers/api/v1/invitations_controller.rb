class Api::V1::InvitationsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def create
    invitation = Invitation.new(invitation_params)
    
    invitation.invitation = SecureRandom.hex(30)
    invitation.expires = DateTime.now + 2.days

    # email sending

    invitation.sent = 1

    InvitationsMailer.send_invitation(invitation_params[:email])
        
    if invitation.save
      render json: invitation, status: 201, root: false
    else
      render json: { errors: invitation.errors }, status: 422
    end
  end

  private
    def invitation_params
      params.permit(:email)
    end

end

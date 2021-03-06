class Api::V1::InvitationsController < ApplicationController
  before_action :authenticate_with_token!, except: :check
  respond_to :json  

  ### ROUTE METHODS ###
  def check
    invitation = Invitation.find_by(invitation: params[:invitation])

    if !invitation
      render json: {"error" => "Invitation not found"}, status: 404, root: false
    elsif (invitation.expires > DateTime.now) || (invitation.invitation_type == Invitation::TYPE[:multiple])
      render json: {"success" => "Invitation is valid"}, status: 200, root: false
    else
      render json: {"error" => "Invitation is invalid"}, status: 422, root: false
    end    
  end

  def index
    invitations = Invitation.all

    render json: invitations, status: 200, root: false
  end

  private
    ### ADMIN METHODS ###
    def admin_create
      invitation = Invitation.new(invitation_params)
      
      invitation.invitation = SecureRandom.hex(30)
      invitation.expires = DateTime.now + 2.days

      invitation.sent = 1
      # email sending
      InvitationsMailer.send_invitation(invitation_params[:email], invitation).deliver
          
      if invitation.save
        waiting_list_entry = WaitingList.where(email: invitation_params[:email]).first

        if waiting_list_entry
          waiting_list_entry.sent = 1
          waiting_list_entry.save
        end

        render json: invitation, status: 201, root: false
      else
        render json: { errors: invitation.errors }, status: 422
      end
    end
    ### GENERAL METHODS ###
    def invitation_params
      params.permit(:email)
    end
end

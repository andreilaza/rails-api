class Api::V1::WaitingListController < ApplicationController
  before_action :authenticate_with_token!, :except => [:create]
  respond_to :json  

  def create
    waiting_list_entry = WaitingList.new(waiting_list_params)

    if waiting_list_entry.save
      InvitationsMailer.notify_staff(waiting_list_params[:email]).deliver
      render json: waiting_list_entry, status: 201, root: false
    else
      render json: { errors: waiting_list_entry.errors }, status: 422
    end
  end

  private
    def waiting_list_params
      params.permit(:email)
    end

    def author_index
      waiting_list = WaitingList.all    

      render json: waiting_list, status: 200, root: false
    end
end

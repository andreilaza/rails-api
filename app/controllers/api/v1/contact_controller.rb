class Api::V1::ContactController < ApplicationController  
  respond_to :json
  
  def create
    message = ContactFeedback.new(contact_params)

    if message.save
      ContactMailer.contact_support(message).deliver
      render json: message, status: 201, root: false
    else
      render json: { errors: message.errors }, status: 422
    end
  end

  private
    def contact_params
      params.permit(:name, :email, :message)
    end
end

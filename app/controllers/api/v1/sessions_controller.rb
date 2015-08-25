class Api::V1::SessionsController < ApplicationController

  def create
    user_email    = params[:session][:email]
    user_password = params[:session][:password]

    user = user_email.present? && User.find_by(email: user_email)

    if user.nil?
      render json: { errors: "Invalid email or password" }, status: 422
    elsif user.valid_password? user_password 
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      
      # convert user to json to add the auth token field to it      
      output = ActiveSupport::JSON.decode(user.to_json)
      output["auth_token"] = user[:auth_token]

      render json: output.to_json, status: 200, location: [:api, user]
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_authentication_token!
    user.save
    head 204
  end
end
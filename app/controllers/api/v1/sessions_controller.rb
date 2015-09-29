class Api::V1::SessionsController < ApplicationController
  respond_to :json

  def signup
    user = User.new(user_params)    
    user.role = User::ROLES[:estudent]

    invitation = Invitation.find_by(invitation: params[:invitation])
    
    if !invitation || invitation.expires < DateTime.now
      render json: { errors: 'Invitation expired' }, status: 422
    elsif user.save
      if params[:avatar]
        append_asset(user)
      end

      # convert user to json to add the auth token field to it      
      output = ActiveSupport::JSON.decode(user.to_json)
      output["auth_token"] = user[:auth_token]

      render json: output.to_json, status: 201, root: false
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def create
    user_email    = params[:session][:email]
    user_password = params[:session][:password]

    user = user_email.present? && User.find_by(email: user_email)

    if user.nil?
      render json: { errors: "Invalid email or password" }, status: 422
    elsif user.valid_password? user_password 
      sign_in user
      user.generate_authentication_token!
      user.save
      
      # convert user to json to add the auth token field to it      
      output = ActiveSupport::JSON.decode(user.to_json)

      if output["role"] == 1
        output["role"] = 'admin'
      end

      if output["role"] == 2
        output["role"] = 'estudent'
      end

      output["auth_token"] = user[:auth_token]

      asset = Asset.where('entity_id' => user.id, 'entity_type' => 'user', 'definition' => 'avatar').first
      
      if asset
        output["avatar"] = asset.path
      else
        output["avatar"] = nil
      end

      render json: output.to_json, status: 200, root: false
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

  def reset_password
    PasswordMailer.reset_password(user_params[:email], current_user).deliver
    head 201
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    
    user.generate_authentication_token!
    user.save
    head 204
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation, :role, :first_name, :last_name)
    end

    def append_asset(user)
      asset = {
        'entity_id'   => user[:id],
        'entity_type' => 'user',
        'path'        => params[:avatar],
        'definition'  => 'avatar'
      }      
      add_asset(asset)
    end
end
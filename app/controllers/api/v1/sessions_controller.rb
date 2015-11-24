require 'aws-sdk'

class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_with_token!, :except => [:signup, :create, :reset_password]
  respond_to :json

  def signup
    user = User.new(user_params)    
    user.role = User::ROLES[:estudent]

    invitation = Invitation.find_by(invitation: params[:invitation])
    
    if !invitation || invitation.expires < DateTime.now
      render json: { errors: 'Invitation expired' }, status: 422
    elsif user.save
      if params[:avatar]
        append_asset(user, params[:avatar])
      end

      # credentials = JSON.load(File.read('secrets.json'))
      set_aws_credentials

      s3 = Aws::S3::Client.new
      hex = SecureRandom.hex(4)
      user_avatar = "users/user_#{hex}"

      bucket = Aws::S3::Bucket.new(ENV["AWS_BUCKET"], client: s3)
      avatar = Aws::S3::Object.new(ENV["AWS_BUCKET"], user_avatar)      

      # from an IO object
      File.open('avatar.png', 'rb') do |file|
        acl = "public-read"
        avatar.put(body:file, acl: acl)        
        append_asset(user, user_avatar)
      end
      
      UserMailer.send_confirmation(user).deliver      
      output = build_output(user)
      
      render json: output, status: 201, root: false
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
      
      output = build_output(user)

      render json: output, status: 200, root: false
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

  def reset_password
    user = User.find_by(:email =>  user_params[:email])
    
    if user
      new_password = SecureRandom.hex(4)
      user.password = new_password
      user.save
      PasswordMailer.reset_password(user_params[:email], new_password).deliver
      head 201
    else
      render json: { errors: "Invalid email" }, status: 422
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    
    user.generate_authentication_token!
    user.save
    head 204
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation, :role, :first_name, :last_name, :username)
    end

    def append_asset(user, avatar)
      asset = {
        'entity_id'   => user[:id],
        'entity_type' => 'user',
        'path'        => avatar,
        'definition'  => 'avatar'
      }      
      add_asset(asset)
    end    
end
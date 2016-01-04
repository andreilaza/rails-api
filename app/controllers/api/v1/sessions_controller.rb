require 'aws-sdk'

class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_with_token!, :except => [:signup, :create, :reset_password]
  respond_to :json

  def signup
    user = User.new(user_params)    
    user.role = User::ROLES[:estudent]

    if params[:facebook_uid]
      existing_user = User.where('email = ? AND email IS NOT NULL', params[:email]).first
      if existing_user
        existing_user.facebook_uid = params[:facebook_uid]        
        add_token(existing_user)
        if existing_user.save
          output = build_output(existing_user)
        
          render json: output, status: 201, root: false
        else
          render json: { errors: existing_user.errors }, status: 422
        end
      else
        user.password = SecureRandom.hex(4)
        user.email = params[:email]       
        
        add_user(user, true)
      end
    else
      add_user(user)
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
      token = UserAuthenticationToken.new
      user.user_authentication_tokens << token            
      user.auth_token = token.token
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
    user_authentication_token = UserAuthenticationToken.find_by(token: params[:id])    
    user_authentication_token.destroy
    head 204
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation, :role, :first_name, :last_name, :username, :facebook_uid)
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

    def add_token(user) 
      token = UserAuthenticationToken.new
      user.user_authentication_tokens << token            
      user.auth_token = token.token
    end

    def add_user(user, facebook = false)
      if user.save
        if params[:avatar]
          append_asset(user, params[:avatar])
        end
        
        set_aws_credentials

        s3 = Aws::S3::Client.new
        hex = SecureRandom.hex(4)
        user_avatar = "users/" + user.id.to_s + "_#{hex}"

        bucket = Aws::S3::Bucket.new(ENV["AWS_BUCKET"], client: s3)
        avatar = Aws::S3::Object.new(ENV["AWS_BUCKET"], user_avatar)

        avatar_url = 'avatar.png'

        if facebook
          # RETRIEVE FACEBOOK AVATAR AND POST IT TO S3
          facebook_avatar_url = 'https://graph.facebook.com/' + params[:facebook_uid].to_s + '/picture?width=720&height=720'
          
          image = MiniMagick::Image.open(facebook_avatar_url)
          image = resize_and_crop_square(image, 400)
          avatar_url = image.path
        end

        # from an IO object
        File.open(avatar_url, 'rb') do |file|
          acl = "public-read"
          avatar.put(body:file, acl: acl)        
          append_asset(user, user_avatar)
        end
        
        UserMailer.send_confirmation(user).deliver

        add_token(user)
        output = build_output(user)
        
        render json: output, status: 201, root: false
      else
        render json: { errors: user.errors }, status: 422
      end 
    end
end
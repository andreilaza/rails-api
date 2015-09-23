class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy]
  respond_to :json

  def show
    user = User.find(params[:id])

    if user
      render json: user, status: 201, root: false
    else
      render json: { errors: user.errors }, status: 422
    end

  end

  def create
    user = User.new(user_params)

    if user.save

      if params[:avatar]
        append_asset(user)
      end

      render json: user, status: 201, root: false
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = current_user

    if user.update(user_params)

      if params[:avatar]
        append_asset(user)
      end

      render json: user, status: 200, root: false
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    current_user.destroy

    head 204    
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation, :first_name, :last_name)
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

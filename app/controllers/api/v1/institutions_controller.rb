class Api::V1::InstitutionsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    respond_with Institution.all.to_json
  end

  def show
    respond_with Institution.find(params[:id])    
  end

  def create
    institution = Institution.new(institution_params)    
    
    if institution.save
      render json: institution, status: 201, location: [:api, institution]
    else
      render json: { errors: institution.errors }, status: 422
    end
  end

  def update
    institution = Institution.find(params[:id])

    if institution.update(institution_params)
      render json: institution, status: 200, location: [:api, institution]
    else
      render json: { errors: institution.errors }, status: 422
    end

  end

  def destroy
    institution = Institution.find(params[:id])
    institution.destroy

    head 204    
  end

  ## Custom Actions ##
  def create_users
    institution = Institution.find(params[:id])
    user = User.create(user_params)
    institution.institution_users.create(:user_id => user.id)

    if !user.save
      render json: { errors: user.errors }, status: 422
    elsif !institution.save
      render json: { errors: institution.errors }, status: 422
    else
      render json: institution, status: 200, location: [:api, institution]
    end
  end

  def list_users
    institution = Institution.find(params[:id])

    render json: institution.users.to_json(:except => [:auth_token]), status: 200, location: [:api, institution]    
  end

  def list_courses
    institution = Institution.find(params[:id])

    render json: institution.courses.to_json, status: 200, location: [:api, institution]    
  end

  private
    def institution_params
      params.require(:institution).permit(:title, :description, :image)
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end

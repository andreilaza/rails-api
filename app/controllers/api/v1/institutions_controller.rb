class Api::V1::InstitutionsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

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

  private
    def institution_params
      params.require(:institution).permit(:title, :description, :image)
    end
end

class Api::V1::SectionsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    respond_with Section.all.to_json
  end

  def show
    respond_with Section.find(params[:id])
  end  

  def update
    section = Section.find(params[:id])

    if section.update(section_params)
      render json: section, status: 200, location: [:api, section]
    else
      render json: { errors: section.errors }, status: 422
    end

  end

  def destroy
    section = Section.find(params[:id])
    section.destroy

    head 204    
  end  

  private
    def section_params
      params.require(:section).permit(:title, :description, :chapter_id, :section_type)
    end
end

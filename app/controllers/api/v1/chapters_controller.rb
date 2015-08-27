class Api::V1::ChaptersController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    respond_with Chapter.all.to_json
  end

  def show
    chapter = Chapter.find(params[:id])

    if chapter
      render json: chapter, status: 200, location: [:api, chapter], root: false
    else
      render json: { errors: chapter.errors }, status: 404
    end
  end  

  def update
    chapter = Chapter.find(params[:id])

    if chapter.update(chapter_params)
      render json: chapter, status: 200, location: [:api, chapter], root: false
    else
      render json: { errors: chapter.errors }, status: 422
    end

  end

  def destroy
    chapter = Chapter.find(params[:id])
    chapter.destroy

    head 204    
  end

  ## Sections actions ##

  def add_section
    section = Section.new(section_params)
    section.chapter_id = params[:id]

    highest_order_section = Section.order(order: :desc).first
    section.order = highest_order_section.order + 1

    if section.save
      render json: section, status: 201, location: [:api, section], root: false
    else
      render json: { errors: section.errors }, status: 422
    end
  end

  def list_sections
    chapter = Chapter.find(params[:id])
    
    render json: chapter.sections.order(order: :desc).to_json, status: 201, location: [:api, chapter], root: false
  end

  private
    def chapter_params
      params.require(:chapter).permit(:title, :description, :image)
    end

    def section_params
      params.require(:chapter).permit(:title, :description, :chapter_id, :section_type)
    end
end

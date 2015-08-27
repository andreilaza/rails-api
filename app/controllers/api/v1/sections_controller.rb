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

  ## Questions actions ##

  def add_question
    question = Question.new(question_params)
    question.section_id = params[:id]

    if question.save
      render json: question, status: 201, location: [:api, question]
    else
      render json: { errors: question.errors }, status: 422
    end
  end

  def list_questions
    section = Section.find(params[:id])
    
    render json: section.questions.to_json, status: 201, location: [:api, section]
  end

  private
    def section_params
      params.require(:section).permit(:title, :description, :chapter_id, :section_type)
    end

    def question_params
      params.require(:section).permit(:title, :section_id, :order, :score, :question_type)
    end
end

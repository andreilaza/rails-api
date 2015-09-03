class Api::V1::SectionsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    respond_with Section.all.to_json
  end

  def show
    section = Section.find(params[:id])

    serializer = SectionSerializer.new(section).as_json    
    serializer = serializer['section']
    
    assets = Asset.where('entity_id' => section[:id], 'entity_type' => 'section')

    assets.each do |asset|
      serializer[asset['definition']] = asset['path']
    end

    if section
      render json: serializer, status: 200, location: [:api, section], root: false
    else
      render json: { errors: section.errors }, status: 422
    end
  end  

  def update
    section = Section.find(params[:id])

    if section.update(section_params)
      serializer = SectionSerializer.new(section).as_json
      serializer = serializer['section']

      if params[:content]
        asset = {
          'entity_id'   => section[:id],
          'entity_type' => 'section',
          'path'        => params[:content],
          'definition'  => 'content'
        }
        add_asset(asset)
        serializer['content'] = params[:content]
      end
      render json: serializer, status: 200, location: [:api, section], root: false
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

    highest_order_question = Question.order(order: :desc).first
    question.order = highest_order_question.order + 1
    
    if question.save
      render json: question, status: 201, location: [:api, question], root: false
    else
      render json: { errors: question.errors }, status: 422
    end
  end

  def list_questions
    section = Section.find(params[:id])
    
    render json: section.questions.order(order: :desc).to_json, status: 201, location: [:api, section], root: false
  end

  private
    def section_params
      params.permit(:title, :description, :chapter_id, :section_type)
    end

    def question_params
      params.permit(:title, :section_id, :order, :score, :question_type)
    end
end

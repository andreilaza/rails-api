class Api::V1::QuestionsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    respond_with Question.all.to_json
  end

  def show
    question = Question.find(params[:id])

    if question
      render json: question, status: 200, location: [:api, question], root: false
    else
      render json: { errors: question.errors }, status: 404
    end
  end  

  def update
    question = Question.find(params[:id])

    if question.update(question_params)
      render json: question, status: 200, location: [:api, question], root: false
    else
      render json: { errors: question.errors }, status: 422
    end

  end

  def destroy
    question = Question.find(params[:id])
    question.destroy

    head 204    
  end  

  private
    def question_params
      params.require(:section).permit(:title, :section_id, :order, :score, :question_type)
    end
end

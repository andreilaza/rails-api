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

  ## Questions actions ##

  def add_answer
    answer = Answer.new(answer_params)
    answer.question_id = params[:id]

    highest_order_answer = Answer.order(order: :desc).first

    if !highest_order_answer
      answer.order = 1
    else
      answer.order = highest_order_answer.order + 1
    end
    
    if answer.save
      render json: answer, status: 201, location: [:api, answer], root: false
    else
      render json: { errors: answer.errors }, status: 422
    end
  end

  def list_answers
    question = Question.find(params[:id])
    
    render json: question.answers.order(order: :desc).to_json, status: 201, location: [:api, question], root: false
  end

  def destroy
    question = Question.find(params[:id])
    question.destroy

    head 204    
  end  

  private
    def question_params
      params.require(:question).permit(:title, :section_id, :order, :score, :question_type)
    end

    def answer_params
      params.permit(:title, :question_id, :order, :correct)
    end
end

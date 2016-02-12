class Api::V1::QuestionHintsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  private
    ### AUTHOR METHODS ###    
    def author_show
      question_hint = QuestionHint.find(params[:id])

      if question_hint
        render json: question_hint, status: 200, root: false
      else
        render json: { errors: question_hint.errors }, status: 404
      end
    end     

    def author_update
      question_hint = QuestionHint.find(params[:id])
    
      if question_hint.update(question_hint_params)
        render json: question_hint, status: 200, root: false
      else
        render json: { errors: question_hint.errors }, status: 422
      end      
    end

    def author_destroy
      question_hint = QuestionHint.find(params[:id])
      question_hint.destroy

      head 204    
    end

    ### GENERAL METHODS ###
    def question_hint_params
      params.permit(:title, :video_moment_id, :question_id)
    end
end

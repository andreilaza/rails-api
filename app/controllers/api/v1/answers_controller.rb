class Api::V1::AnswersController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json
  
  private
    def answer_params
      params.require(:answer).permit(:title, :section_id, :order, :score, :correct, :answer_type)
    end

    def author_index
      respond_with Answer.all.to_json
    end

    def author_show
      answer = Answer.find(params[:id])

      if answer
        render json: answer, status: 200, root: false
      else
        render json: { errors: answer.errors }, status: 404
      end
    end
    
    def author_update
      answer = Answer.find(params[:id])

      if answer.update(answer_params)
        render json: answer, status: 200, root: false
      else
        render json: { errors: answer.errors }, status: 422
      end

    end
    
    def author_destroy
      answer = Answer.find(params[:id])
      answer.destroy

      head 204    
    end  
end

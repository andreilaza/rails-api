class Api::V1::CategoriesController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def show
    category =  Category.find(params[:id])

    if category
      render json: category, status: 200, root: false
    else
      render json: { errors: category.errors }, status: 404
    end
  end

  def update
    category = Category.find(params[:id])

    if category.update(category_params)      
      render json: category, status: 200, root: false
    else
      render json: { errors: category.errors }, status: 422
    end
  end

  def destroy
    category = Category.find(params[:id])
    category.destroy

    head 204    
  end

  private
    def category_params
      params.permit(:title, :description, :domain_id)
    end
end

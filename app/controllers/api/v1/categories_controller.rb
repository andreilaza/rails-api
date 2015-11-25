class Api::V1::CategoriesController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json  

  def list_courses
    send("#{current_user.role_name}_list_courses")
  end

  private
    def admin_show
      category =  Category.find(params[:id])

      if category
        render json: category, status: 200, root: false
      else
        render json: { errors: category.errors }, status: 404
      end
    end

    def admin_update
      category = Category.find(params[:id])

      if category.update(category_params)      
        render json: category, status: 200, root: false
      else
        render json: { errors: category.errors }, status: 422
      end
    end

    def admin_destroy
      category = Category.find(params[:id])
      category.destroy

      head 204    
    end
    
    def category_params
      params.permit(:title, :description, :domain_id)
    end

    def estudent_list_courses
      courses = Course.joins(:category_courses, :categories).where('categories.id' => params[:id], 'courses.published' => true).all 
      
      render json: courses, status: 200, root: false
    end
end

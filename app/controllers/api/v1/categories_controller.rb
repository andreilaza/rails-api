class Api::V1::CategoriesController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json  

  def list_courses
    send("#{current_user.role_name}_list_courses")
  end

  private
    def admin_show
      category =  Category.find_by("id = ? OR slug = ?", params[:id], params[:id])

      if category
        render json: category, status: 200, root: false
      else
        render json: { errors: category.errors }, status: 404
      end
    end

    def admin_update
      category = Category.find_by("id = ? OR slug = ?", params[:id], params[:id])

      if category.update(category_params)
        if params[:title]
          slug_string = slugify(category.title)
          category = check_existing_slug(category, 'category', slug_string)
          category.save
        end
        render json: category, status: 200, root: false
      else
        render json: { errors: category.errors }, status: 422
      end
    end

    def admin_destroy
      category = Category.find_by("id = ? OR slug = ?", params[:id], params[:id])
      category.destroy

      head 204    
    end
    
    def category_params
      params.permit(:title, :description, :domain_id)
    end

    def estudent_list_courses
      category = Category.find_by("id = ? OR slug = ?", params[:id], params[:id])
      courses = Course.joins(:category_courses, :categories).where('categories.id' => category.id, 'courses.published' => true).all
      
      render json: courses, status: 200, root: false
    end
end

class Api::V1::CategoriesController < ApplicationController
  before_action :authenticate_with_token!, except: [:show]
  respond_to :json  

  ### ROUTE METHODS ###
  def list_courses
    send("#{current_user.role_name}_list_courses")
  end
  
  def show
    category =  Category.find(params[:id])

    if category
      render json: category, status: 200, root: false
    else
      render json: { errors: category.errors }, status: 404
    end
  end

  private
    ### ADMIN METHODS ###
    def admin_update
      category =  Category.find(params[:id])
      
      if params[:title]    
        category.friendly_id
        category.slug = nil
        title = params[:title].dup
        category.clean_title = clean_title(title)
      end

      if category.update(category_params)        
        render json: category, status: 200, root: false
      else
        render json: { errors: category.errors }, status: 422
      end
    end

    def admin_destroy
      category =  Category.find(params[:id])
      category.destroy

      head 204    
    end

    ### ESTUDENT METHODS ###
    def estudent_list_courses
      category =  Category.find(params[:id])
      courses = Course.joins(:category_course, :category).where('categories.id' => category.id, 'courses.status' => Course::STATUS[:published]).all
      
      render json: courses, status: 200, root: false
    end

    ### GENERAL METHODS ###
    def category_params
      params.permit(:title, :description, :domain_id)
    end
end

class Api::V1::ChaptersController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  ### ROUTE METHODS ###
  def index
    respond_with Chapter.all.to_json
  end

  def show
    chapter = Chapter.find(params[:id])

    if chapter
      render json: chapter, status: 200, root: false
    else
      render json: { errors: chapter.errors }, status: 404
    end
  end

  def add_section
    send("#{current_user.role_name}_add_section")
  end

  def list_sections
    send("#{current_user.role_name}_list_sections")
  end
  
  private
    ### AUTHOR METHODS ###
    def author_update    
      chapter = Chapter.find(params[:id])
      if check_permission(chapter)        
        if params[:title]
          chapter.friendly_id
          chapter.slug = nil      
          title = params[:title].dup
          chapter.clean_title = clean_title(title)
        end
          
        if chapter.update(chapter_params)          
          render json: chapter, status: 200, root: false
        else
          render json: { errors: chapter.errors }, status: 422
        end
      else
        render json: { errors: 'Course not found' }, status: 404
      end
    end

    def author_destroy
      chapter = Chapter.find(params[:id])
      chapter.destroy

      head 204    
    end

    def author_add_section
      chapter = Chapter.find(params[:id])
      if check_permission(chapter)
        section = Section.new(section_params)
        section.chapter_id = params[:id]
        section.course_id = chapter.course_id
        highest_order_section = Section.order(order: :desc).first

        if highest_order_section
          section.order = highest_order_section.order + 1
        else
          section.order = 1
        end

        section.friendly_id
        section.slug = nil
        title = params[:title].dup
        section.clean_title = clean_title(title)

        if section.save          
          render json: section, status: 201, root: false
        else
          render json: { errors: section.errors }, status: 422
        end
      else
        render json: { errors: 'Course not found' }, status: 404 
      end
    end

    def author_list_sections
      chapter = Chapter.find(params[:id])
      
      render json: chapter.sections.order(order: :desc).to_json, status: 201, root: false
    end

    ### GENERAL METHODS ###
    def chapter_params
      params.require(:chapter).permit(:title, :description, :image)
    end

    def section_params
      params.permit(:title, :description, :chapter_id, :section_type)
    end   

    def check_permission(chapter)
      # Check if author has permission to access this course
      course_permission = CourseInstitution.where(course_id: chapter.course_id, institution_id: current_user.institution_id).first
    end 
end

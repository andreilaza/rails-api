class Api::V1::ChaptersController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    respond_with Chapter.all.to_json
  end

  def show
    chapter = Chapter.find_by("id = ? OR slug = ?", params[:id], params[:id])

    if chapter
      render json: chapter, status: 200, root: false
    else
      render json: { errors: chapter.errors }, status: 404
    end
  end  

  ## Sections actions ##
  def add_section
    send("#{current_user.role_name}_add_section")
  end

  def list_sections
    send("#{current_user.role_name}_list_sections")
  end
  
  private    
    def author_update    
      chapter = Chapter.find_by("id = ? OR slug = ?", params[:id], params[:id])
      if check_permission(chapter)
        if chapter.update(chapter_params)
          if params[:title]
            slug_string = slugify(chapter.title)
            chapter = check_existing_slug(chapter, 'chapter', slug_string)
            chapter.save
          end
          
          render json: chapter, status: 200, root: false
        else
          render json: { errors: chapter.errors }, status: 422
        end
      else
        render json: { errors: 'Course not found' }, status: 404 
      end
    end

    def author_destroy
      chapter = Chapter.find_by("id = ? OR slug = ?", params[:id], params[:id])
      chapter.destroy

      head 204    
    end

    def author_add_section
      chapter = Chapter.find_by("id = ? OR slug = ?", params[:id], params[:id])
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

        if section.save
          if params[:title]
            slug_string = slugify(section.title)
            section = check_existing_slug(section, 'section', slug_string)
            section.save
          end
          render json: section, status: 201, root: false
        else
          render json: { errors: section.errors }, status: 422
        end
      else
        render json: { errors: 'Course not found' }, status: 404 
      end
    end

    def author_list_sections
      chapter = Chapter.find_by("id = ? OR slug = ?", params[:id], params[:id])
      
      render json: chapter.sections.order(order: :desc).to_json, status: 201, root: false
    end


    def chapter_params
      params.require(:chapter).permit(:title, :description, :image)
    end

    def section_params
      params.permit(:title, :description, :chapter_id, :section_type)
    end   

    def check_permission(chapter)
      # Check if admin has permission to access this course      
      course_permission = CourseInstitution.where(course_id: chapter.course_id, institution_id: current_user.institution_id).first
    end 
end

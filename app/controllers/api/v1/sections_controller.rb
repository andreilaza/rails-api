class Api::V1::SectionsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    sections = Section.all    

    render json: sections, status: 200, root: false
  end

  def show
    section = Section.find_by("id = ? OR slug = ?", params[:id], params[:id])
    
    if section
      render json: section, serializer: CustomSectionSerializer, status: 200, root: false
    else
      render json: { errors: section.errors }, status: 422
    end
  end

  def content_asset
    send("#{current_user.role_name}_content_asset")
  end  

  ## Questions actions ##
  def add_question
    send("#{current_user.role_name}_add_question")
  end
  def list_questions
    send("#{current_user.role_name}_list_questions")
  end  

  private
    def append_asset(section_id, path, metadata, definition)
      asset = {
        'entity_id'   => section_id,
        'entity_type' => 'section',
        'path'        => path,
        'metadata'    => metadata,
        'definition'  => definition
      }

      add_asset(asset)
    end

    def author_update
      section = Section.find_by("id = ? OR slug = ?", params[:id], params[:id])
      if check_permission(section)
        if section.update(section_params)
          if params[:content]            
            append_asset(section.id, params[:content][:path], params[:content][:metadata], 'content')
          end        

          if params[:subtitles]
            append_asset(section.id, params[:subtitles], nil, 'subtitles')
          end

          if params[:title]
            slug_string = slugify(section.title)
            section = check_existing_slug(section, 'section', slug_string)
            section.save
          end

          render json: section, serializer: CustomSectionSerializer, status: 200, root: false
        else
          render json: { errors: section.errors }, status: 422
        end
      else
        render json: { errors: 'Course not found' }, status: 404 
      end
    end

    def estudent_update
      section = Section.find_by("id = ? OR slug = ?", params[:id], params[:id])
      
      student_section = StudentsSection.where(course_id: section.course_id, user_id: current_user.id, section_id: section.id).first
      
      if student_section.update(student_section_params)
        students_course = StudentsCourse.where(course_id: student_section.course_id, user_id: current_user.id).first
        students_course.touch
        next_student_section = StudentsSection.where(user_id: current_user.id, completed: false, course_id: section.course_id).first

        if next_student_section
          next_section = Section.find(next_student_section.section_id)        
        else
          next_section = nil
        end

        if next_section
          #TO-DO add course progress ??        
        else
          students_course.completed = true
          students_course.save
          
          next_section = {'course_completed' => true}
        end

        if next_section.is_a?(ActiveRecord::Base)
          next_section = {              
              'section' => serialize_section(next_section)
          }
        end

        render json: next_section, status: 200, root: false    
      else
        render json: { errors: 'Course not found' }, status: 404 
      end
    end

    def author_destroy
      section = Section.find_by("id = ? OR slug = ?", params[:id], params[:id])
      section.destroy

      head 204    
    end  

    def section_params
      params.permit(:title, :description, :chapter_id, :section_type, :duration)
    end

    def student_section_params
      params.permit(:completed)
    end

    def author_add_question 
      section = Section.find_by("id = ? OR slug = ?", params[:id], params[:id])
      if check_permission(section)
        question = Question.new(question_params)
        question.section_id = section.id
        question.course_id = section.course_id
        
        highest_order_question = Question.order(order: :desc).first
        
        if highest_order_question
          question.order = highest_order_question.order + 1
        else
          question.order = 1
        end
        
        if question.save
          render json: question, status: 201, root: false
        else
          render json: { errors: question.errors }, status: 422
        end
      else
        render json: { errors: 'Course not found' }, status: 404 
      end
    end

    def author_list_questions
      section = Section.find_by("id = ? OR slug = ?", params[:id], params[:id])
      
      render json: section.questions.order(order: :desc).to_json, status: 201, root: false
    end

    def question_params
      params.permit(:title, :section_id, :order, :score, :question_type)
    end     

    def check_permission(section)
      # Check if admin has permission to access this course      
      course_permission = CourseInstitution.where(course_id: section.course_id, institution_id: current_user.institution_id).first
    end 
end

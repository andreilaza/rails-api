class Api::V1::SectionsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    sections = Section.all    

    render json: sections, status: 200, root: false
  end

  def show
    section = Section.find(params[:id])
        
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
    def author_update
      section = Section.find(params[:id])
      if check_permission(section)
        if section.update(section_params)
          if params[:content]
            append_asset(section)
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
      student_section = StudentsSection.where(user_id: current_user.id, section_id: params[:id]).first
      
      if student_section.update(student_section_params)
        students_course = StudentsCourse.where(course_id: student_section.course_id, user_id: current_user.id).first
        students_course.touch
        next_student_section = StudentsSection.where(user_id: current_user.id, completed: false).first

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
      section = Section.find(params[:id])
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
      section = Section.find(params[:id])   
      if check_permission(section)
        question = Question.new(question_params)
        question.section_id = params[:id]

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
      section = Section.find(params[:id])
      
      render json: section.questions.order(order: :desc).to_json, status: 201, root: false
    end

    def question_params
      params.permit(:title, :section_id, :order, :score, :question_type)
    end

    def append_asset(section)
      asset = {
        'entity_id'   => section[:id],
        'entity_type' => 'section',
        'path'        => params[:content][:path],
        'metadata'    => params[:content][:metadata],
        'definition'  => 'content'
      }
      add_asset(asset)
      
    end

    def author_content_asset
      asset = Asset.find(params[:id])
      asset.destroy

      head 204
    end 

    def check_permission(section)
      # Check if admin has permission to access this course      
      chapter = Chapter.find(section.chapter_id)
      course_permission = CourseInstitution.where(course_id: chapter.course_id, institution_id: current_user.institution_id).first
    end 
end

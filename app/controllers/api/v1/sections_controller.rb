class Api::V1::SectionsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    sections = Section.all

    response = []
    
    sections.each do |section|      
      serializer = serialize_section(section)
      response.push(serializer)
    end

    render json: response, status: 200, root: false
  end

  def show
    section = Section.find(params[:id])

    section = serialize_section(section)

    if section
      render json: section, status: 200, location: [:api, section], root: false
    else
      render json: { errors: section.errors }, status: 422
    end
  end  

  def admin_update
    section = Section.find(params[:id])
    if check_permission
      if section.update(section_params)
        if params[:content]
          append_asset(section)
        end
        
        section = serialize_section(section)

        render json: section, status: 200, location: [:api, section], root: false
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
      next_student_section = StudentsSection.where(user_id: current_user.id, completed: false).first

      if next_student_section
        next_section = Section.find(next_student_section.section_id)
      else
        next_section = nil
      end

      if next_section
        #TO-DO add course progress ??
        next_section = serialize_section(next_section)      
      end

      render json: next_section, status: 200, location: [:api, next_section], root: false    
    else
      render json: { errors: 'Course not found' }, status: 404 
    end
  end

  def destroy
    section = Section.find(params[:id])
    section.destroy

    head 204    
  end  

  ## Questions actions ##

  def add_question    
    if check_permission
      question = Question.new(question_params)
      question.section_id = params[:id]

      highest_order_question = Question.order(order: :desc).first
      question.order = highest_order_question.order + 1
      
      if question.save
        render json: question, status: 201, location: [:api, question], root: false
      else
        render json: { errors: question.errors }, status: 422
      end
    else
      render json: { errors: 'Course not found' }, status: 404 
    end
  end

  def list_questions
    section = Section.find(params[:id])
    
    render json: section.questions.order(order: :desc).to_json, status: 201, location: [:api, section], root: false
  end

  private
    def section_params
      params.permit(:title, :description, :chapter_id, :section_type)
    end

    def student_section_params
      params.permit(:completed)
    end

    def question_params
      params.permit(:title, :section_id, :order, :score, :question_type)
    end

    def append_asset(section)
      asset = {
        'entity_id'   => section[:id],
        'entity_type' => 'section',
        'path'        => params[:content],
        'definition'  => 'content'
      }
      add_asset(asset)
      
    end    

    def check_permission
      # Check if admin has permission to access this course
      section = Section.find(params[:id])
      chapter = Chapter.find(section.chapter_id)
      course_permission = CourseInstitution.where(course_id: chapter.course_id, institution_id: current_user.institution_id).first
    end 
end

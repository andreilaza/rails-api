class Api::V1::SectionsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  ### ROUTE METHODS ###
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
  
  def add_question
    send("#{current_user.role_name}_add_question")
  end

  def list_questions
    send("#{current_user.role_name}_list_questions")
  end  

  def feedback
    send("#{current_user.role_name}_feedback")
  end

  def add_video_moment
    send("#{current_user.role_name}_add_video_moment")
  end

  def list_video_moments
    send("#{current_user.role_name}_list_video_moments")
  end

  def add_setting
    send("#{current_user.role_name}_add_setting")
  end

  def list_settings
    send("#{current_user.role_name}_list_settings")
  end

  def retake
    send("#{current_user.role_name}_retake")
  end

  private
    ### AUTHOR METHODS ###
    def author_update
      section = Section.find(params[:id])
      if check_permission(section)
        section.friendly_id
        section.slug = nil
        section.clean_title = clean_title(section.title)

        if section.update(section_params)
          if params[:content]            
            append_asset(section.id, params[:content][:path], params[:content][:metadata], 'content')
          end        

          if params[:subtitles]
            append_asset(section.id, params[:subtitles], nil, 'subtitles')
          end          

          render json: section, serializer: CustomSectionSerializer, status: 200, root: false
        else
          render json: { errors: section.errors }, status: 422
        end
      else
        render json: { errors: 'Course not found' }, status: 404 
      end
    end

    def author_destroy
      section = Section.find(params[:id])
      section.destroy

      head 204    
    end   

    def author_add_question 
      section = Section.find(params[:id])
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
      section = Section.find(params[:id])
      
      render json: section.questions.order(order: :desc).to_json, status: 201, root: false
    end

    def author_add_video_moment   
      section = Section.find(params[:id])
      if check_permission(section)
        video_moment = VideoMoment.new(video_moment_params)    
        video_moment.section_id = params[:id]
        if video_moment.save        
          render json: video_moment, status: 201, root: false
        else
          render json: { errors: video_moment.errors }, status: 422
        end
      else
        render json: { errors: 'Course not found' }, status: 404 
      end
    end

    def author_list_video_moments
      section = Section.find(params[:id])
      
      render json: section.video_moments, status: 201, root: false
    end

    def author_add_setting
      section = Section.find(params[:id])
      if check_permission(section)        
        setting = SectionSetting.where(handle: params[:handle]).first
        if setting
          setting.value = params[:value]
        else
          setting = SectionSetting.new
          setting.section_id = params[:id]
          setting.handle = params[:handle]
          setting.value = params[:value]
        end

        if setting.save        
          render json: setting, status: 201, root: false
        else
          render json: { errors: setting.errors }, status: 422
        end
      else
        render json: { errors: 'Course not found' }, status: 404 
      end
    end

    def author_list_settings
      sections = SectionSetting.all    

      render json: sections, status: 200, root: false
    end

    ### ESTUDENT METHODS ###
    def estudent_update
      section = Section.find(params[:id])
      
      student_section = StudentsSection.where(course_id: section.course_id, user_id: current_user.id, section_id: section.id).first
      
      if student_section.update(student_section_params)
        students_course = StudentsCourse.where(course_id: student_section.course_id, user_id: current_user.id).first
        students_course.touch
        next_student_section = StudentsSection.where(user_id: current_user.id, completed: false, finished: false, course_id: section.course_id).first

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

    def estudent_feedback
      feedback = SectionFeedback.new(feedback_params)
      section = Section.find(params[:id])
      
      feedback.section_id = section.id
      feedback.user_id = current_user.id
      if feedback.save
        UserMailer.send_feedback(current_user, feedback_params[:feedback], section.title).deliver
        render json: feedback, status: 201, root: false
      else
        render json: { errors: feedback.errors }, status: 422
      end
    end

    def estudent_retake
      student_section = StudentsSection.where(user_id: current_user.id, section_id: params[:id]).first

      if student_section.finished == true || student_section.completed == true
        previous = StudentsQuestion.where(user_id: current_user.id, section_id: params[:id]).first
        
        questions = Question.where(section_id: params[:id]).order(order: :asc).all
        questions.each do |question|
          students_question = StudentsQuestion.new()

          students_question.course_id = student_section.course_id
          students_question.user_id = current_user.id
          students_question.section_id = student_section.section_id
          students_question.question_id = question.id
          students_question.score = question.score
          students_question.try = previous.try + 1
          students_question.save
        end        

        student_section.save
      end

      section = Section.find(params[:id])

      render json: section, status: 201, root: false
    end

    ### GENERAL METHODS ###
    def section_params
      params.permit(:title, :description, :chapter_id, :section_type, :duration)
    end

    def feedback_params
      params.permit(:feedback)
    end

    def student_section_params
      params.permit(:completed)
    end

    def question_params
      params.permit(:title, :section_id, :order, :score, :question_type)
    end   

    def video_moment_params
      params.permit(:title, :section_id, :time)
    end  

    def check_permission(section)
      # Check if admin has permission to access this course      
      course_permission = CourseInstitution.where(course_id: section.course_id, institution_id: current_user.institution_id).first
    end 

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
end

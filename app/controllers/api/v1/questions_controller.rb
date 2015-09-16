class Api::V1::QuestionsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    respond_with Question.all.to_json
  end

  def show
    question = Question.find(params[:id])

    if question
      render json: question, status: 200, location: [:api, question], root: false
    else
      render json: { errors: question.errors }, status: 404
    end
  end  

  def admin_update
    if check_permission
      question = Question.find(params[:id])

      if question.update(question_params)
        render json: question, status: 200, location: [:api, question], root: false
      else
        render json: { errors: question.errors }, status: 422
      end
    else
      render json: { errors: 'Course not found' }, status: 404 
    end
  end

  def estudent_update
    answer = Answer.find(params[:answer])

    question = Question.find(params[:id])

    if answer.correct
      course = Course.joins(chapters: [{ sections: :questions }]).where('questions.id' => params[:id]).first      

      existing = StudentsQuestion.where(section_id: question.section_id, user_id: current_user.id, question_id: question.id).first

      if existing
        students_question = existing
      else
        students_question = StudentsQuestion.new()
      end

      students_question.course_id = course.id
      students_question.section_id = question.section_id
      students_question.question_id = question.id
      students_question.user_id = current_user.id
      students_question.completed = true      

      questions_count = Question.where(section_id: question.section_id).count
      students_question_count = StudentsQuestion.where(section_id: question.section_id).count

      students_question.remaining = questions_count - students_question_count - 1

      students_question.save

      if students_question.remaining == 0
        # Next Section
        students_section = StudentsSection.where(user_id: current_user.id, section_id: students_question.section_id).first
        students_section.completed = true
        students_section.save        

        response = next_section(question)
        render json: response, status: 200, root: false
      else
        # Next Question
        
        response = next_section(question)
        render json: response, status: 200, root: false    
      end
    else
      response = next_section(question)
      render json: response, status: 200, root: false
    end
  end
  ## Questions actions ##

  def add_answer    
    if check_permission
      answer = Answer.new(answer_params)
      answer.question_id = params[:id]

      highest_order_answer = Answer.order(order: :desc).first

      if !highest_order_answer
        answer.order = 1
      else
        answer.order = highest_order_answer.order + 1
      end
      
      if answer.save
        render json: answer, status: 201, location: [:api, answer], root: false
      else
        render json: { errors: answer.errors }, status: 422
      end
    else
      render json: { errors: 'Course not found' }, status: 404 
    end
  end

  def list_answers
    question = Question.find(params[:id])
    
    render json: question.answers.order(order: :desc).to_json, status: 201, location: [:api, question], root: false
  end

  def destroy
    question = Question.find(params[:id])
    question.destroy

    head 204    
  end  

  private
    def question_params
      params.require(:question).permit(:title, :section_id, :order, :score, :question_type)
    end

    def answer_params
      params.permit(:title, :question_id, :order, :correct)
    end

    def check_permission
      # Check if admin has permission to access this course
      question = Question.find(params[:id])
      section = Section.find(question.section_id)
      chapter = Chapter.find(section.chapter_id)
      course_permission = CourseInstitution.where(course_id: chapter.course_id, institution_id: current_user.institution_id).first
    end

    def next_section(question)
      current_section = StudentsSection.find(question.section_id)      
      if current_section && current_section.completed == false
        next_student_section = current_section
      else
        next_student_section = StudentsSection.where(user_id: current_user.id, completed: false).first
      end
      
      if next_student_section
        next_section = Section.find(next_student_section.section_id)
      else
        next_section = nil
      end
        
      if next_section
        #TO-DO add course progress ??
        next_section = serialize_section(next_section)                
      else
        nil
      end

      next_section
    end
end

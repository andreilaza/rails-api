class Api::V1::QuestionsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json
  
  ### ROUTE METHODS ###
  def add_answer
    send("#{current_user.role_name}_add_answer")
  end
  
  def list_answers
    send("#{current_user.role_name}_list_answers")
  end  

  def add_hint
    send("#{current_user.role_name}_add_hint")
  end
  
  def list_hints
    send("#{current_user.role_name}_list_hints")
  end  

  private
    ### AUTHOR METHODS ###    
    def author_index
      respond_with Question.all.to_json
    end

    def author_show
      question = Question.find(params[:id])

      if question
        render json: question, status: 200, root: false
      else
        render json: { errors: question.errors }, status: 404
      end
    end 
    
    def author_update
      question = Question.find(params[:id])
      if check_permission(question)        

        if question.update(question_params)
          render json: question, status: 200, root: false
        else
          render json: { errors: question.errors }, status: 422
        end
      else
        render json: { errors: 'Course not found' }, status: 404 
      end
    end

    def author_destroy
      question = Question.find(params[:id])
      question.destroy

      head 204    
    end

    def author_add_answer
      question = Question.find(params[:id])
      if check_permission(question)
        answer = Answer.new(answer_params)
        answer.question_id = params[:id]
        answer.course_id = question.course_id
        
        highest_order_answer = Answer.order(order: :desc).first

        if !highest_order_answer
          answer.order = 1
        else
          answer.order = highest_order_answer.order + 1
        end
        
        if answer.save
          render json: answer, status: 201, root: false
        else
          render json: { errors: answer.errors }, status: 422
        end
      else
        render json: { errors: 'Question not found' }, status: 404 
      end
    end

    def author_list_answers
      question = Question.find(params[:id])
      
      render json: question.answers.order(order: :desc).to_json, status: 201, root: false
    end

    def author_add_hint
      question = Question.find(params[:id])
      if check_permission(question)
        question_hint = QuestionHint.new(question_hints_params)
        question_hint.question_id = params[:id]
                
        if question_hint.save
          render json: question_hint, status: 201, root: false
        else
          render json: { errors: question_hint.errors }, status: 422
        end
      else
        render json: { errors: 'Question not found' }, status: 404 
      end        
    end

    def author_list_hints
      respond_with QuestionHint.all
    end

    ### ESTUDENT METHODS ###
    def estudent_update
      correct_answers = Answer.where(:question_id => params[:id], :correct => true).all
      payload_answers = Answer.where(:question_id => params[:id], :correct => true, :id => params[:answers]).all

      question = Question.find(params[:id])

      ok = false    

      if correct_answers.length == payload_answers.length && correct_answers.length == params[:answers].length
        ok = true
      end

      if ok        
        existing = StudentsQuestion.where(section_id: question.section_id, user_id: current_user.id, question_id: question.id).first

        if existing
          students_question = existing
        else
          students_question = StudentsQuestion.new()
        end

        students_question.course_id = question.course_id
        students_question.section_id = question.section_id
        students_question.question_id = question.id
        students_question.user_id = current_user.id
        students_question.completed = true      

        questions_count = Question.where(section_id: question.section_id).count
        students_question_count = StudentsQuestion.where(section_id: question.section_id, user_id: current_user.id).count

        students_question.remaining = questions_count - students_question_count - 1

        students_question.save

        if students_question.remaining == 0
          # Next Section
          students_section = StudentsSection.where(user_id: current_user.id, section_id: students_question.section_id, course_id: question.course_id).first
          students_section.completed = true
          students_section.save        

          response = next_section(question)        
        else
          # Next Question
          
          response = next_section(question)        
        end
      else
        response = next_section(question)      
      end

      # Update Students Course
      students_section = StudentsSection.where(user_id: current_user.id, section_id: question.section_id, course_id: question.course_id).first
      if students_section
        students_course = StudentsCourse.where(course_id: students_section.course_id, user_id: current_user.id).first
        students_course.touch
      end

      if !response.has_key?("course_completed")
        response = {        
            'correct' => ok,
            'section' => response        
        }
      else
        response["correct"] = ok
      end

      render json: response, status: 200, root: false
    end    

    ### GENERAL METHODS ###
    def next_section(question)
      current_section = StudentsSection.where(user_id: current_user.id, section_id: question.section_id, course_id: question.course_id).first
      
      if current_section && current_section.completed == false
        next_student_section = current_section
      else
        next_student_section = StudentsSection.where(user_id: current_user.id, completed: false, course_id: current_section.course_id).first
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
        students_course = StudentsCourse.where(course_id: question.course_id, user_id: current_user.id).first
        students_course.completed = true
        students_course.save
        
        next_section = {'course_completed' => true}
        
      end

      next_section
    end
    
    def question_params
      params.require(:question).permit(:title, :section_id, :order, :score, :question_type)
    end

    def question_hints_params
      params.permit(:title, :video_moment_id)
    end

    def answer_params
      params.permit(:title, :question_id, :order, :correct)
    end

    def check_permission(question)
      # Check if admin has permission to access this course            
      course_permission = CourseInstitution.where(course_id: question.course_id, institution_id: current_user.institution_id).first
    end

end

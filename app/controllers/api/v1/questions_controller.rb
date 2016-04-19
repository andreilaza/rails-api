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

      ok = false      
      if correct_answers.length == payload_answers.length && correct_answers.length == params[:answers].length
        ok = true
      end

      student_question = StudentsQuestion.where('question_id' => params[:id], 'user_id' => current_user.id).order(try: :desc).first
      
      if ok
        student_question.completed = true
      else
        student_question.finished = true    
      end

      set_answer_permission(true, student_question.question_id)

      if params[:hint]
        student_question.hint = true
      end

      student_question.save

      student_course = StudentsCourse.where('course_id = ? AND user_id = ?', student_question.course_id, current_user.id).first
      student_course.touch      

      remaining_questions = StudentsQuestion.where('section_id = ? AND user_id = ? AND finished = 0 AND completed = 0 AND try = ?', student_question.section_id, current_user.id, student_question.try).first
      response = {}
      if remaining_questions
        next_section = Section.find(remaining_questions.section_id)        
      else
        student_section = StudentsSection.where('section_id = ? AND user_id = ?', student_question.section_id, current_user.id).first

        total_score = StudentsQuestion.where('section_id = ? AND user_id = ? AND try = ?', student_question.section_id, current_user.id, student_question.try).sum(:score)
        student_score = StudentsQuestion.where('section_id = ? AND user_id = ? AND completed = 1 AND try = ?', student_question.section_id, current_user.id, student_question.try).sum(:score)
        
        required_to_pass = SectionSetting.where(section_id: student_question.section_id, handle: 'required_to_pass').first
        
        if !required_to_pass
          required_to_pass = Section::SETTING[:required_to_pass]
        end

        percentage = student_score * 100 / total_score

        if percentage < required_to_pass
          student_section.finished = true
        else
          student_section.completed = true
        end

        student_section.save

        # save student snapshot
        quiz_snapshot = QuizSnapshot.new
        quiz_snapshot.section_id = student_question.section_id
        quiz_snapshot.user_id = current_user.id
        quiz_snapshot.score = student_score
        quiz_snapshot.passed = student_section.completed
        quiz_snapshot.save

        next_student_section = StudentsSection.where('course_id = ? AND user_id = ? AND finished = 0 AND completed = 0', student_question.course_id, current_user.id).first
        
        course_response = nil
        if next_student_section
          next_section = Section.find(next_student_section.section_id)
        else
          finished = StudentsSection.where('course_id = ? AND user_id = ? AND finished = 1 AND completed = 0', student_question.course_id, current_user.id).count          

          if finished > 0
            student_course.finished = true
            response =  {
              :course_finished => true,
              :correct => ok
            }
            
          else
            student_course.completed = true
            response =  {
              :course_completed => true,
              :correct => ok
            }
          end
          student_course.save
        end
      end
      
      section = CustomSectionSerializer.new(next_section, scope: current_user, root: false)
      question = Question.find(params[:id])
      question = QuestionSerializer.new(question, scope: current_user, root: false)
      
      response[:correct] = ok        
      response[:quiz_snapshot] = quiz_snapshot
      response[:question] = question              

      if quiz_snapshot != nil
        response[:section] = section
      end
      
      render json: response, status: 201, root: false
    
    end    
    
    def estudent_list_answers
      author_list_answers
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
      puts question.course_id
      puts current_user.institution_id

      ci = CourseInstitution.all
      ci.each do |item|
        puts item.course_id
        puts item.institution_id
      end
      course_permission = CourseInstitution.where(course_id: question.course_id, institution_id: current_user.institution_id).first
    end

end

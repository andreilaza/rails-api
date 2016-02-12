require 'spec_helper'

RSpec.describe Api::V1::QuestionsController, type: :controller do
  describe "Author actions" do
    before(:each) do
      @user = FactoryGirl.create(:user, :author)
      api_authorization_header @user.auth_token 
    end

    describe "GET #index" do
      before(:each) do        
        get :index
      end

      it "returns 4 institutions from the database" do        
        json_response.each do |question|
          expect(question.keys).to contain_exactly(:id, :title, :section_id, :order, :score, :question_type, :course_id, :created_at, :updated_at)
        end      
      end

      it { should respond_with 200 }
    end

    describe "GET #show" do
      before(:each) do
        @question = FactoryGirl.create :question
        get :show, id: @question.id
      end

      it "returns the information about an institution" do
        expect(json_response[:title]).to eql @question.title
      end

      it { should respond_with 200 }
    end
    describe "Permission actions" do
      before(:each) do
        @course = FactoryGirl.create :course, title: "Institution Course"
        @course_institution = FactoryGirl.create :course_institution, course_id: @course.id, institution_id: @user.institution[:id]          
        @chapter = FactoryGirl.create :chapter, course_id: @course.id
        @section = FactoryGirl.create :section, chapter_id: @chapter.id
        @question = FactoryGirl.create :question, section_id: @section.id, course_id: @course.id
      end

      describe "PUT #update" do
        context "when is successfully updated" do
          before(:each) do            
            put :update, { id: @question.id, title: "New title"}
          end

          it "renders the json representation for the updated question" do          
            expect(json_response[:title]).to eql "New title"
          end

          it { should respond_with 200 }
        end
      end

      describe "POST #add_answer" do
        before(:each) do
          post :add_answer, { id: @question.id, title: "New answer", description: "A description"}
        end

        it "renders the json representation for the new answer" do          
          expect(json_response[:title]).to eql "New answer"
        end

        it { should respond_with 201 }
      end

      describe "POST #add_hint" do
        before(:each) do
          post :add_hint, { id: @question.id, title: "New hint", video_moment_id: 12}
        end

        it "renders the json representation for the new answer" do          
          expect(json_response[:title]).to eql "New hint"
        end

        it { should respond_with 201 }
      end
    end

    describe "DELETE #destroy" do
      before(:each) do
        @question = FactoryGirl.create :question
        delete :destroy, { id: @question.id }
      end

      it { should respond_with 204 }
    end

    describe "GET #list_answers" do
      before(:each) do
        @question = FactoryGirl.create :question
        @answer = FactoryGirl.create(:answer, question_id: @question.id, title: "Answer")
        get :list_answers, id: @question.id
      end

      it "returns the information about an domain" do        
        json_response.each do |answer|
          expect(answer[:title]).to eql "Answer"
        end
      end

      it { should respond_with 201 }
    end

    describe "GET #list_hints" do
      before(:each) do
        @question = FactoryGirl.create :question
        @hint = FactoryGirl.create(:question_hint, question_id: @question.id, title: "Hint")
        get :list_answers, id: @question.id
      end

      it "returns the information about an domain" do        
        json_response.each do |hint|
          expect(hint[:title]).to eql "Hint"
        end
      end

      it { should respond_with 201 }
    end
  end

  describe "Estudent practice action PUT #update" do
    before(:each) do
      @user = FactoryGirl.create(:user, :estudent)
      @author = FactoryGirl.create(:user, :author, email: "author@estudent.ro")
      api_authorization_header @user.auth_token

      ##### MOCK COURSE #####
      @course = FactoryGirl.create :course, title: "Practice Course", status: Course::STATUS[:published]
      @course_institution = FactoryGirl.create :course_institution, course_id: @course.id, institution_id: @author.institution[:id]          
      @chapter = FactoryGirl.create :chapter, course_id: @course.id

      @section_one = FactoryGirl.create :section, chapter_id: @chapter.id, section_type: Section::TYPE[:quiz], title: "First Section"
      @section_two = FactoryGirl.create :section, chapter_id: @chapter.id, section_type: Section::TYPE[:quiz], title: "Second Section"      

      @question_one = FactoryGirl.create :question, section_id: @section_one.id, course_id: @course.id
      @question_two = FactoryGirl.create :question, section_id: @section_two.id, course_id: @course.id

      @answer_one = FactoryGirl.create :answer, question_id: @question_one.id, correct: 1
      @answer_two = FactoryGirl.create :answer, question_id: @question_one.id, correct: 0

      @answer_three = FactoryGirl.create :answer, question_id: @question_two.id, correct: 1
      @answer_four = FactoryGirl.create :answer, question_id: @question_two.id, correct: 0

      ##### START COURSE #####
      @students_course = FactoryGirl.create :students_course, user_id: @user.id, course_id: @course.id

      @students_section_one = FactoryGirl.create :students_section, user_id: @user.id, course_id: @course.id, chapter_id: @chapter.id, section_id: @section_one.id
      @students_section_two = FactoryGirl.create :students_section, user_id: @user.id, course_id: @course.id, chapter_id: @chapter.id, section_id: @section_two.id
      
      @students_question_one = FactoryGirl.create :students_question, user_id: @user.id, course_id: @course.id, question_id: @question_one.id, section_id: @question_one.section_id
      @students_question_one = FactoryGirl.create :students_question, user_id: @user.id, course_id: @course.id, question_id: @question_two.id, section_id: @question_two.section_id            
    end

    describe "Answer first question correctly" do
      before(:each) do
        put :update, { id: @question_one.id, answers: [@answer_one.id] }
      end

      it "should respond with the next section" do
        expect(json_response[:title]).to eql @section_two.title
        expect(json_response[:completed]).to eql false
        expect(json_response[:finished]).to eql false
      end

      it { should respond_with 200 }
    end

    describe "Answer first question incorrectly" do
      before(:each) do
        put :update, { id: @question_one.id, answers: [@answer_two.id] }
      end

      it "should respond with the next section" do
        expect(json_response[:title]).to eql @section_two.title
        expect(json_response[:completed]).to eql false
        expect(json_response[:finished]).to eql false
      end

      it { should respond_with 200 }
    end

    describe "Answer both questions correctly" do
      before(:each) do
        put :update, { id: @question_one.id, answers: [@answer_one.id] }
        put :update, { id: @question_two.id, answers: [@answer_three.id] }
      end

      it "should respond with course completed" do        
        expect(json_response[:course_completed]).to eql true
      end

      it { should respond_with 200 }
    end

    describe "Answer one question correctly and the other incorrectly" do
      before(:each) do
        put :update, { id: @question_one.id, answers: [@answer_one.id] }
        put :update, { id: @question_two.id, answers: [@answer_four.id] }
      end

      it "should respond with course completed" do        
        expect(json_response[:course_finished]).to eql true
      end

      it { should respond_with 200 }
    end
  end
end

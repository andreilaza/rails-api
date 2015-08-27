require 'spec_helper'

describe Api::V1::QuestionsController do
  before(:each) do
    @user = FactoryGirl.create :user
    api_authorization_header @user.auth_token 
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :question }
      get :index

      it "returns 4 questions from the database" do
        questions_response = json_response
        expect(questions_response[:questions]).to have(4).items
      end

      it { should respond_with 200 }
    end
  end

  describe "GET #show" do
    before(:each) do
      @question = FactoryGirl.create :question
      get :show, id: @question.id
    end

    it "returns the information about a question" do
      questions_response = json_response[:question]
      expect(questions_response[:title]).to eql @question.title
    end

    it { should respond_with 200 }
  end  

  describe "DELETE #destroy" do
    before(:each) do
      @question = FactoryGirl.create :question      
      delete :destroy, { id: @question.id }
    end

    it { should respond_with 204 }

  end

end

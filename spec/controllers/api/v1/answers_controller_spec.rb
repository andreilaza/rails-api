require 'spec_helper'

RSpec.describe Api::V1::AnswersController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create(:user, :author)
    api_authorization_header @user.auth_token 
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :answer }    
      get :index
    end

    it "returns 4 answers from the database" do
      answers_response = json_response
      answers_response.each do |answer|
        expect(answer[:title]).to eql "My Answer"
      end
    end

    it { should respond_with 200 }
    
  end

  describe "GET #show" do
    before(:each) do
      @answer = FactoryGirl.create :answer
      get :show, id: @answer.id
    end

    it "returns the information about an answer" do
      answers_response = json_response
      expect(answers_response[:title]).to eql @answer.title
    end

    it { should respond_with 200 }
  end  

  describe "DELETE #destroy" do
    before(:each) do
      @answer = FactoryGirl.create :answer      
      delete :destroy, { id: @answer.id }
    end

    it { should respond_with 204 }

  end
end

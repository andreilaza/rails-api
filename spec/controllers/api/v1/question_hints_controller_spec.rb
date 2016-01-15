require 'spec_helper'

RSpec.describe Api::V1::QuestionHintsController, type: :controller do
  describe "Author actions" do
    before(:each) do
      @user = FactoryGirl.create(:user, :author)
      @question = FactoryGirl.create :question
      @hint = FactoryGirl.create :question_hint, question_id: @question.id
      api_authorization_header @user.auth_token 
    end

    describe "GET #show" do
      before(:each) do        
        get :show, id: @hint.id
      end

      it "returns the information about an institution" do
        hint_response = json_response      
        expect(hint_response[:title]).to eql @hint.title
      end

      it { should respond_with 200 }
    end

    describe "PUT #update" do
      context "when is successfully updated" do
        before(:each) do          
          put :update, { id: @hint.id, title: "New Title"}
        end

        it "renders the json representation for the updated domain" do
          hint_response = json_response
          expect(hint_response[:title]).to eql "New Title"
        end

        it { should respond_with 200 }
      end
    end

    describe "DELETE #destroy" do
      before(:each) do
        @hint = FactoryGirl.create :question_hint
        delete :destroy, { id: @hint.id }
      end

      it { should respond_with 204 }

    end
  end
end

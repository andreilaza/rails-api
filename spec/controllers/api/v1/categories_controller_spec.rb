require 'spec_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do
  describe "PUT #update && DELETE #destroy - admin" do
    before(:each) do
      @user = FactoryGirl.create(:user, :admin)
      api_authorization_header @user.auth_token 
    end

    describe "PUT/PATCH #update" do    
      context "when is successfully updated" do
        before(:each) do
          @category = FactoryGirl.create :category
          put :update, { id: @category.id, title: "New title"}
        end

        it "renders the json representation for the updated category" do
          category_response = json_response
          expect(category_response[:title]).to eql "New title"
        end

        it { should respond_with 200 }
      end    
    end

    describe "DELETE #destroy" do
      before(:each) do
        @category = FactoryGirl.create :category
        delete :destroy, { id: @category.id }
      end

      it { should respond_with 204 }

    end
  end
  
  describe "GET #show && GET #list_courses - estudent" do
    before(:each) do
      @user = FactoryGirl.create(:user, :estudent)
      api_authorization_header @user.auth_token 
    end
    describe "GET #show" do
      before(:each) do
        @category = FactoryGirl.create :category        
        get :show, id: @category.id
      end

      it { should respond_with 200 }
    end

    describe "GET #list_courses" do
      before(:each) do
        @category = FactoryGirl.create :category
        @course = FactoryGirl.create :course
        @institution = FactoryGirl.create :institution
        @course_institution = FactoryGirl.create :course_institution, course_id: @course.id, institution_id: @institution.id
        category_course = FactoryGirl.create(:category_course, course_id: @course.id, category_id: @category.id)
        get :list_courses, id: @category.id
      end

      it "returns the courses" do
        category_response = json_response
        # puts category_response
        category_response.each do |course|
          expect(course[:title]).to eql @course.title
        end
      end

      it { should respond_with 200 }
    end
  end  
end
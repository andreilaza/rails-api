require 'spec_helper'

describe Api::V1::CoursesController do
  before(:each) do
    @user = FactoryGirl.create :user
    api_authorization_header @user.auth_token 
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :course }
      get :index

      it "returns 4 courses from the database" do
        courses_response = json_response
        expect(courses_response[:courses]).to have(4).items
      end

      it { should respond_with 200 }
    end
  end

  describe "GET #show" do
    before(:each) do
      @course = FactoryGirl.create :course
      get :show, id: @course.id
    end

    it "returns the information about an course" do
      courses_response = json_response
      expect(courses_response[:title]).to eql @course.title
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "successfully created" do
      before(:each) do
        @course_attributes = FactoryGirl.attributes_for :course
        post :create, { course: @course_attributes }
      end

      it "renders the json representation for the course record just created" do
        courses_response = json_response
        expect(courses_response[:title]).to eql @course_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context "not created" do
      before(:each) do        
        @course_attributes = FactoryGirl.attributes_for :course
        @course_attributes[:title] = nil
        post :create, { course: @course_attributes }

      end

      it "renders an errors json" do
        courses_response = json_response        
        expect(courses_response).to have_key(:errors)
      end

      it "renders the json errors on why the course could not be created" do
        courses_response = json_response
        expect(courses_response[:errors][:title]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    context "successfully updated" do
      before(:each) do
        @course = FactoryGirl.create :course
        put :update, {id: @course.id, course: { description: "New Description" }}
      end

      it "renders the json representation for the updated course" do
        courses_response = json_response
        expect(courses_response[:description]).to eql "New Description"
      end

      it { should respond_with 200 }
    end

    context "not updated" do
      # do something here ..
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @course = FactoryGirl.create :course      
      delete :destroy, { id: @course.id }
    end

    it { should respond_with 204 }

  end

end

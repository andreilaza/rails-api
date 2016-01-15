require 'spec_helper'

RSpec.describe Api::V1::InstitutionsController, type: :controller do
  describe "Admin actions" do
    before(:each) do
      @user = FactoryGirl.create(:user, :admin)
      api_authorization_header @user.auth_token 
    end

    describe "GET #index" do
      before(:each) do
        # 4.times { FactoryGirl.create :institution }
        get :index
      end

      it "returns 4 institutions from the database" do
        institution_response = json_response        
        institution_response.each do |institution|
          expect(institution.keys).to contain_exactly(:id, :title, :description, :url, :logo, :has_institution_admin, :slug)
        end      
      end

      it { should respond_with 201 }
      
    end

    describe "POST #create" do    
      context "when is successfully created" do
        before(:each) do
          @domain = FactoryGirl.create :institution
          post :create, {title: "New title"}
        end

        it "renders the json representation for the institution" do
          institution_response = json_response
          expect(institution_response[:title]).to eql "New title"
        end

        it { should respond_with 201 }
      end   

      context "when it is not successfully created" do
        before(:each) do
          @domain = FactoryGirl.create :institution
          post :create, {}
        end

        it "renders the json representation for the updated institution" do
          institution_response = json_response
          expect(institution_response[:errors][:title]).to include "can't be blank"
        end

        it { should respond_with 422 }
      end    
    end

    describe "PUT/PATCH #update" do    
      context "when is successfully updated" do
        before(:each) do
          @institution = FactoryGirl.create :institution
          put :update, { id: @institution.id, title: "New title"}
        end

        it "renders the json representation for the updated institution" do
          institution_response = json_response
          expect(institution_response[:title]).to eql "New title"
        end

        it { should respond_with 200 }
      end    
    end

    describe "DELETE #destroy" do
      before(:each) do
        @institution = FactoryGirl.create :institution
        delete :destroy, { id: @institution.id }
      end

      it { should respond_with 204 }
    end

    describe "POST #create_users" do
      before(:each) do
        @institution = FactoryGirl.create :institution
        post :create_users, { id: @institution.id, role: "institution_admin", facebook:"facebook address", password: "password", password_confirmation: "password", first_name: "Coralia", last_name: "Sulea", email: "coralia@estudent.ro"}
      end

      it "renders the json representation for the updated domain" do
        institution_response = json_response
        expect(institution_response[:email]).to eql "coralia@estudent.ro"
        expect(institution_response[:facebook]).to eql "facebook address"
      end

      it { should respond_with 200 }
    end
  end

  describe "Author actions" do
    before(:each) do
      @user = FactoryGirl.create(:user, :author)
      api_authorization_header @user.auth_token       
    end

    describe "GET #list_courses" do
      before(:each) do
        @institution = FactoryGirl.create :institution
        4.times {
          @course = FactoryGirl.create :course, title: "Institution Course"
          @course_institution = FactoryGirl.create :course_institution, course_id: @course.id, institution_id: @institution.id
        }
        get :list_courses, { id: @institution.id }
      end

      it "should return the courses of this institution" do
        institution_response = json_response
        institution_response.each do |course|
          expect(course[:title]).to eql "Institution Course"
        end
      end

      it { should respond_with 200 }
    end
  end

  describe "Estudent actions" do
    before(:each) do
      @user = FactoryGirl.create(:user, :estudent)
      api_authorization_header @user.auth_token 
    end

    describe "GET #show" do
      before(:each) do
        @institution = FactoryGirl.create :institution
        @course = FactoryGirl.create :course        
        @author = FactoryGirl.create(:user, :author, email: "new_email@estudent.ro")
        @author_courses = FactoryGirl.create :author_course, user_id: @author.id, course_id: @course.id      
        @course_institution = FactoryGirl.create :course_institution, course_id: @course.id, institution_id: @institution.id, user_id: @author.id
        @institution_user = FactoryGirl.create :institution_user, user_id: @author.id, institution_id: @institution.id
        get :show, id: @institution.id
      end

      it "returns the information about an institution" do
        institution_response = json_response      
        expect(institution_response[:title]).to eql @institution.title
      end

      it { should respond_with 200 }
    end
  end

  describe "Institution Admin actions" do
    before(:each) do
      @user = FactoryGirl.create(:user, :institution_admin)
      @institution = FactoryGirl.create :institution
      @institution_user = FactoryGirl.create :institution_user, user_id: @user.id, institution_id: @institution.id        
      api_authorization_header @user.auth_token 
    end

    describe "GET #show" do
      before(:each) do        
        get :show, id: @institution.id
      end

      it "returns the information about an institution" do
        institution_response = json_response      
        expect(institution_response[:title]).to eql @institution.title
      end

      it { should respond_with 201 }
    end

    describe "PUT #update" do
      context "when is successfully updated" do
        before(:each) do          
          put :update, { id: @institution.id, title: "New title"}
        end

        it "renders the json representation for the updated domain" do
          institution_response = json_response
          expect(institution_response[:title]).to eql "New title"
        end

        it { should respond_with 200 }
      end
    end

    describe "POST #create_users" do
      before(:each) do        
        post :create_users, { id: @institution.id, role: "author", facebook:"facebook address", password: "password", password_confirmation: "password", first_name: "Coralia", last_name: "Sulea", email: "coralia@estudent.ro"}
      end

      it "renders the json representation for the updated domain" do
        institution_response = json_response
        expect(institution_response[:email]).to eql "coralia@estudent.ro"
        expect(institution_response[:facebook]).to eql "facebook address"
      end

      it { should respond_with 200 }
    end

    describe "GET #list_users" do
      before(:each) do        
        get :list_users, { id: @institution.id }
      end

      it "renders the json representation for the updated domain" do
        institution_response = json_response
        institution_response.each do |user|
          expect(user[:email]).to eql "andrei.test@estudent.ro"
        end                
      end

      it { should respond_with 200 }
    end
  end
end
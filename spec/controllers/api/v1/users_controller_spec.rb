require 'spec_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "POST #check_username" do
    describe "when it is available" do
      before(:each) do
        @estudent = FactoryGirl.create(:user, :estudent)
        post :check_username_availability, { :username => "test-estudent-username" }
      end

      it "should respond with true" do        
        expect(json_response).to eql true
      end

      it { should respond_with 200 }
    end

    describe "when it is NOT available" do
      before(:each) do
        @estudent = FactoryGirl.create(:user, :estudent)
        post :check_username_availability, { :username => "username" }
      end

      it "should respond with false" do        
        expect(json_response).to eql false
      end

      it { should respond_with 200 }
    end
  end

  describe "POST #check_email" do
    describe "when it is available" do
      before(:each) do
        @estudent = FactoryGirl.create(:user, :estudent)
        post :check_email_availability, { :email => "andrei.test2@estudent.ro" }
      end

      it "should respond with true" do        
        expect(json_response).to eql true
      end

      it { should respond_with 200 }
    end

    describe "when it is NOT available" do
      before(:each) do
        @estudent = FactoryGirl.create(:user, :estudent)
        post :check_email_availability, { :email => "andrei.test@estudent.ro" }
      end

      it "should respond with true" do        
        expect(json_response).to eql false
      end

      it { should respond_with 200 }
    end
  end

  describe "GET #admin_show" do
    before(:each) do 
      @user = FactoryGirl.create(:user, :admin)
      api_authorization_header @user.auth_token
      get :show, id: @user.id
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 201 }
  end

  describe "GET #institution_admin_show" do
    before(:each) do 
      @user = FactoryGirl.create(:user, :institution_admin)
      @user_metadata = FactoryGirl.create(:user_metadatum)
      @institution = FactoryGirl.create(:institution)      
      api_authorization_header @user.auth_token
      get :show, id: @user.id
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 201 }
  end

  describe "GET #author_show" do
    before(:each) do 
      @user = FactoryGirl.create(:user, :author)
      @user_metadata = FactoryGirl.create(:user_metadatum)
      @institution = FactoryGirl.create(:institution)      
      api_authorization_header @user.auth_token
      get :show, id: @user.id
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 201 }
  end

  describe "GET #estudent_show" do
    before(:each) do 
      @user = FactoryGirl.create(:user, :estudent)      
      api_authorization_header @user.auth_token
      get :show, id: @user.id
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 201 }
  end  

  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { avatar: "asgl/12/asg", email: @user_attributes[:email], password: @user_attributes[:password], password_confirmation: @user_attributes[:password_confirmation]}
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        @invalid_user_attributes = { email: "asd@asd.com", password_confirmation: "12345678" } #notice I'm not including the email        
        post :create, {email:  @invalid_user_attributes[:email]}
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:password]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "POST #change_password" do
    before(:each) do 
      @user = FactoryGirl.create(:user, :estudent)          
      api_authorization_header @user.auth_token      
      post :change_password, {:old_password => "password", :password => "password", :password_confirmation => "password"}
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }

  end

  describe "GET #latest_course" do
    before(:each) do 
      @user = FactoryGirl.create(:user, :estudent)          
      api_authorization_header @user.auth_token      
      @course = FactoryGirl.create(:course)
      @institution = FactoryGirl.create(:institution)      
      @course_institution = FactoryGirl.create(:course_institution, course_id: @course.id, institution_id: @institution.id)
      @students_course = FactoryGirl.create(:students_course, course_id: @course.id, user_id: @user.id)
      get :latest_course
    end

    it "returns the information about the latest course" do      
      user_response = json_response
      expect(user_response[:title]).to eql @course.title
    end
    
    it { should respond_with 200 }
  end

  describe "GET #institution" do
    before(:each) do 
      @user = FactoryGirl.create(:user, :author)          
      api_authorization_header @user.auth_token      
      
      @institution = FactoryGirl.create(:institution)      
      
      get :institution, id: @user.id
    end

    it "returns the information about the latest course" do      
      user_response = json_response
      expect(user_response[:title]).to eql @institution.title
    end
    
    it { should respond_with 200 }
  end

  describe "GET #current" do
    before(:each) do 
      @user = FactoryGirl.create(:user, :author)          
      api_authorization_header @user.auth_token      
      
      get :current, id: @user.id
    end

    it "returns the information about the latest course" do      
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end
    
    it { should respond_with 200 }
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create(:user, :estudent)
      api_authorization_header @user.auth_token 
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { id: @user.id, avatar: "asgl/12/asg", email: "newmail@example.com" }
      end

      it "renders the json representation for the updated user" do
        user_response = json_response
        expect(user_response[:email]).to eql "newmail@example.com"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        patch :update, { id: @user.id, email: "bademail.com" }
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token 
      delete :destroy, { id: @user.id }
    end

    it { should respond_with 204 }

  end
end
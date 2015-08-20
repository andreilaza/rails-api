require 'spec_helper'

describe Api::V1::UsersController do  

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id
    end

    it "returns the information about the user in an json format" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
      expect(user_response.status).to eq(200)
    end    
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, {user: @user_attributes}
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
        expect(json_response.status).to eq(201)
      end      
    end

    context "when is not created" do
      before(:each) do
        @invalid_user_attributes = { password: "12345678", password_confirmation: "12345678" }
        post :create, { user: @invalid_user_attributes }
      end

      it "renders a json error" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it "should respond with 422" do
        expect(json_response.status).to eq(422)
      end
    end
  end

  describe "PUT/PATCH #update" do
    context "when is successfully updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        request.headers['Authorization'] =  @user.auth_token
      end

      it "renders the json data of the updated user" do
        user_response = json_response
        expect(user_response[:email]).to eql "newmail@example.com"
      end

      it "should respond with 200" do
        expect(json_response.status).to eq(200)        
      end
    end

    context "when is not created" do
      before(:each) do
        @user = FactoryGirl.create :user
        request.headers['Authorization'] =  @user.auth_token
      end

      it "renders the json errors on why the user could not be updated" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it "should respond with 422" do
        expect(json_response.status).to eq(422)
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      delete :destroy, id: @user.id
    end

    it "should respond with 204" do
      expect(json_response.status).to eq(204)      
    end
  end

end
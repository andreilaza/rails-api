require 'spec_helper'

describe Api::V1::InstitutionsController do
  before(:each) do
    @user = FactoryGirl.create :user
    api_authorization_header @user.auth_token 
  end

  describe "GET #show" do
    before(:each) do
      @institution = FactoryGirl.create :institution
      get :show, id: @institution.id
    end

    it "returns the information about an institution" do
      institution_response = json_response
      expect(institution_response[:title]).to eql @institution.title
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "successfully created" do
      before(:each) do
        @institution_attributes = FactoryGirl.attributes_for :institution
        post :create, { institution: @institution_attributes }
      end

      it "renders the json representation for the institution record just created" do
        institution_response = json_response
        expect(institution_response[:title]).to eql @institution_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context "not created" do
      before(:each) do        
        @institution_attributes = FactoryGirl.attributes_for :institution
        @institution_attributes[:title] = nil
        post :create, { institution: @institution_attributes }

      end
            
      it "renders an errors json" do
        institution_response = json_response        
        expect(institution_response).to have_key(:errors)
      end

      it "renders the json errors on why the institution could not be created" do
        institution_response = json_response
        expect(institution_response[:errors][:title]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end
end

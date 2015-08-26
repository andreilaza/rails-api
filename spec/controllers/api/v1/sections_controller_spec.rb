require 'spec_helper'

describe Api::V1::SectionsController do
  before(:each) do
    @user = FactoryGirl.create :user
    api_authorization_header @user.auth_token 
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :section }
      get :index

      it "returns 4 sections from the database" do
        sections_response = json_response
        expect(sections_response[:sections]).to have(4).items
      end

      it { should respond_with 200 }
    end
  end

  describe "GET #show" do
    before(:each) do
      @section = FactoryGirl.create :section
      get :show, id: @section.id
    end

    it "returns the information about a section" do
      sections_response = json_response[:section]
      expect(sections_response[:title]).to eql @section.title
    end

    it { should respond_with 200 }
  end  

  describe "DELETE #destroy" do
    before(:each) do
      @section = FactoryGirl.create :section      
      delete :destroy, { id: @section.id }
    end

    it { should respond_with 204 }

  end

end

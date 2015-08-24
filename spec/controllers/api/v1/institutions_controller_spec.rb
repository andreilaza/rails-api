require 'spec_helper'

describe Api::V1::InstitutionsController, type: :controller do
  describe "GET #show" do
    before(:each) do
      @institution = FactoryGirl.create :institution
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token 
      get :show, id: @institution.id
    end

    it "returns the information about an institution" do
      institution_response = json_response
      expect(institution_response[:title]).to eql @institution.title
    end

    it { should respond_with 200 }
  end
end

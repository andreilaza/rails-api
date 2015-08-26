require 'spec_helper'

describe Api::V1::ChaptersController do
  before(:each) do
    @user = FactoryGirl.create :user
    api_authorization_header @user.auth_token 
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :chapter }
      get :index

      it "returns 4 chapters from the database" do
        chapters_response = json_response
        expect(chapters_response[:chapters]).to have(4).items
      end

      it { should respond_with 200 }
    end
  end

  describe "GET #show" do
    before(:each) do
      @chapter = FactoryGirl.create :chapter
      get :show, id: @chapter.id
    end

    it "returns the information about a chapter" do
      chapters_response = json_response[:chapter]
      expect(chapters_response[:title]).to eql @chapter.title
    end

    it { should respond_with 200 }
  end  

  describe "DELETE #destroy" do
    before(:each) do
      @chapter = FactoryGirl.create :chapter      
      delete :destroy, { id: @chapter.id }
    end

    it { should respond_with 204 }

  end

end

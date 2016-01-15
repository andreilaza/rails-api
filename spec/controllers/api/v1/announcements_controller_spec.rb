require 'spec_helper'

RSpec.describe Api::V1::AnnouncementsController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create(:user, :admin)
    api_authorization_header @user.auth_token 
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :announcement }
      get :index
    end

    it "returns 4 announcements from the database" do
      announcement_response = json_response
      announcement_response.each do |announcement|
        expect(announcement[:announcement]).to eql "This is a very beautiful announcement"
      end      
    end

    it { should respond_with 201 }
    
  end

  describe "GET #show" do
    before(:each) do
      @announcement = FactoryGirl.create :announcement
      get :show, id: @announcement.id
    end

    it "returns the information about an announcement" do
      announcement_response = json_response      
      expect(announcement_response[:announcement]).to eql @announcement.announcement
    end

    it { should respond_with 201 }
  end

  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @announcement_attributes = FactoryGirl.attributes_for :announcement
        post :create, { announcement: "This is a bad announcement"}
      end

      it "renders the json representation for the user record just created" do
        announcement_response = json_response
        expect(announcement_response[:announcement]).to eql "This is a bad announcement"
      end

      it { should respond_with 201 }
    end    
  end 

  describe "PUT/PATCH #update" do    
    context "when is successfully updated" do
      before(:each) do
        @announcement = FactoryGirl.create :announcement
        put :update, { id: @announcement.id, announcement: "Wow, this announcement is awesome"}
      end

      it "renders the json representation for the updated user" do
        announcement_response = json_response
        expect(announcement_response[:announcement]).to eql "Wow, this announcement is awesome"
      end

      it { should respond_with 200 }
    end    
  end

  describe "DELETE #destroy" do
    before(:each) do
      @announcement = FactoryGirl.create :announcement      
      delete :destroy, { id: @announcement.id }
    end

    it { should respond_with 204 }

  end
end

require 'spec_helper'

RSpec.describe Api::V1::DomainsController, type: :controller do
  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :domain }
      get :index
    end

    it "returns 4 announcements from the database" do
      domain_response = json_response
      domain_response.each do |domain|
        expect(domain[:title]).to eql "First domain"
      end      
    end

    it { should respond_with 200 }
    
  end

  describe "GET #show" do
    before(:each) do
      @domain = FactoryGirl.create :domain
      get :show, id: @domain.id
    end

    it "returns the information about an domain" do
      domain_response = json_response      
      expect(domain_response[:title]).to eql @domain.title
    end

    it { should respond_with 200 }
  end

  describe "GET #list_categories" do
    before(:each) do
      @domain = FactoryGirl.create :domain
      @category = FactoryGirl.create(:category, domain_id: @domain.id, title: "Domain category")
      get :list_categories, id: @domain.id
    end

    it "returns the information about an domain" do
      domain_response = json_response      
      domain_response.each do |category|
        expect(category[:title]).to eql "Domain category"
      end
    end

    it { should respond_with 201 }
  end

  describe "POST #create && PUT #update && DELETE #destroy && POST #add_category - admin" do
    before(:each) do
      @user = FactoryGirl.create(:user, :admin)
      api_authorization_header @user.auth_token 
    end

    describe "POST #create" do    
      context "when is successfully created" do
        before(:each) do
          @domain = FactoryGirl.create :domain
          post :create, {title: "New title"}
        end

        it "renders the json representation for the updated category" do
          domain_response = json_response
          expect(domain_response[:title]).to eql "New title"
        end

        it { should respond_with 201 }
      end   

      context "when it is not successfully created" do
        before(:each) do
          @domain = FactoryGirl.create :domain
          post :create, {}
        end

        it "renders the json representation for the updated domain" do
          domain_response = json_response
          expect(domain_response[:errors][:title]).to include "can't be blank"
        end

        it { should respond_with 422 }
      end    
    end

    describe "PUT/PATCH #update" do    
      context "when is successfully updated" do
        before(:each) do
          @domain = FactoryGirl.create :domain
          put :update, { id: @domain.id, title: "New title"}
        end

        it "renders the json representation for the updated domain" do
          domain_response = json_response
          expect(domain_response[:title]).to eql "New title"
        end

        it { should respond_with 200 }
      end    
    end

    describe "DELETE #destroy" do
      before(:each) do
        @domain = FactoryGirl.create :domain
        delete :destroy, { id: @domain.id }
      end

      it { should respond_with 204 }

    end

    describe "POST #add_category" do
      before(:each) do
        @domain = FactoryGirl.create :domain
        post :add_category, { id: @domain.id, title: "New title", description: "A description"}
      end

      it "renders the json representation for the updated domain" do
        domain_response = json_response
        expect(domain_response[:title]).to eql "New title"
      end
      it { should respond_with 201 }
    end
  end  
end

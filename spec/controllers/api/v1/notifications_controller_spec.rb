require 'spec_helper'

RSpec.describe Api::V1::NotificationsController, type: :controller do
  describe "Estudent actions" do
    before(:each) do
      @user = FactoryGirl.create(:user, :estudent)
      @notification = FactoryGirl.create :notification
      @user_notification = FactoryGirl.create :user_notification, user_id: @user.id, notification_id: @notification.id, status: 0
      api_authorization_header @user.auth_token 
    end

    describe "GET #index" do
      before(:each) do
        # 4.times { FactoryGirl.create :institution }
        get :index
      end

      it "returns notifications from the database" do
        notifications_response = json_response        
        notifications_response.each do |notification|
          expect(notification.keys).to contain_exactly(:id, :entity_id, :notification_type, :course, :seen)
        end      
      end

      it { should respond_with 200 }
      
    end

    describe "GET #show" do
      before(:each) do        
        get :show, id: @notification.id
      end

      it "returns the information about an institution" do
        notifications_response = json_response      
        expect(notifications_response[:entity_id]).to eql @notification.entity_id
      end

      it { should respond_with 200 }
    end

    describe "PUT #update" do
      context "when is successfully updated" do
        before(:each) do          
          put :update, { id: @notification.id, seen: true}
        end

        it "renders the json representation for the updated domain" do
          notifications_response = json_response
          expect(notifications_response[:seen]).to eql true
        end

        it { should respond_with 200 }
      end
    end
  end
end

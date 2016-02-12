require 'spec_helper'

RSpec.describe Api::V1::StudentVideoSnapshotsController, type: :controller do
  describe "Estudent actions" do
    before(:each) do
      @user = FactoryGirl.create(:user, :estudent)      
      api_authorization_header @user.auth_token 
    end
    
    describe "POST #create" do    
      context "when is successfully created" do
        before(:each) do          
          post :create, {time: 235.6, section_id: 1}
        end

        it "renders the json representation for the updated category" do          
          expect(json_response[:time]).to eql 235.6
        end

        it { should respond_with 201 }
      end   

      context "when it is not successfully created" do
        before(:each) do
          @student_video_snapshot = FactoryGirl.create :student_video_snapshot
          post :create, {}
        end

        it "renders the json representation for the updated domain" do          
          expect(json_response[:errors][:time]).to include "can't be blank"
          expect(json_response[:errors][:section_id]).to include "can't be blank"
        end

        it { should respond_with 422 }
      end    
    end

    describe "PUT #update" do
      context "when is successfully updated" do
        before(:each) do
          @student_video_snapshot = FactoryGirl.create :student_video_snapshot
          put :update, { id: @student_video_snapshot.id, time: 3.125}
        end

        it "renders the json representation for the updated domain" do
          
          expect(json_response[:time]).to eql 3.125
        end

        it { should respond_with 200 }
      end
    end

    describe "DELETE #destroy" do
      before(:each) do
        @student_video_snapshot = FactoryGirl.create :student_video_snapshot
        delete :destroy, { id: @student_video_snapshot.id }
      end

      it { should respond_with 204 }

    end
  end
end

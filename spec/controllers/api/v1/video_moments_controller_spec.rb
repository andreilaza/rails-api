require 'spec_helper'

RSpec.describe Api::V1::VideoMomentsController, type: :controller do
  describe "Author actions" do
    before(:each) do
      @user = FactoryGirl.create(:user, :author)      
      api_authorization_header @user.auth_token 
    end

    # describe "GET #index" do
    #   before(:each) do
    #     4.times { FactoryGirl.create :video_moment }
    #     get :index
    #   end

    #   it "returns 4 announcements from the database" do        
    #     json_response.each do |video_moment|
    #       expect(video_moment[:video_moment]).to eql "Video Moment"
    #     end      
    #   end

    #   it { should respond_with 200 }
      
    # end

    describe "GET #show" do
      before(:each) do        
        @video_moment = FactoryGirl.create :video_moment
        get :show, id: @video_moment.id
      end

      it "returns the information about an video moment" do        
        expect(json_response[:time]).to eql @video_moment.time
      end

      it { should respond_with 200 }
    end

    describe "PUT #update" do
      context "when is successfully updated" do
        before(:each) do          
          @video_moment = FactoryGirl.create :video_moment
          put :update, { id: @video_moment.id, title: "New Title"}
        end

        it "renders the json representation for the updated domain" do
          expect(json_response[:title]).to eql "New Title"
        end

        it { should respond_with 200 }
      end
    end

    describe "DELETE #destroy" do
      before(:each) do
        @video_moment = FactoryGirl.create :video_moment
        delete :destroy, { id: @video_moment.id }
      end

      it { should respond_with 204 }

    end
  end
end

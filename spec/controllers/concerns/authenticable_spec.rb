require 'spec_helper'

class Authentication
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe "#current_user" do
    before do
      @user = FactoryGirl.create :user
      request.headers["Authorization"] = @user.auth_token
      allow(authentication).to receive_messages(:request => request)
    end

    it "returns the user from the authorization header" do
      expect(authentication.current_user.auth_token).to eql @user.auth_token
    end
  end

  describe "#roles" do
    it "logs in admin" do
      @admin = FactoryGirl.create(:user, :admin)
      allow(authentication).to receive(:current_user).and_return(@admin)
      expect(authentication.current_user.role).to eql @admin.role      
    end

    it "logs in estudent" do
      @estudent = FactoryGirl.create(:user, :estudent)
      allow(authentication).to receive(:current_user).and_return(@estudent)
      expect(authentication.current_user.role).to eql @estudent.role      
    end

    it "logs in author" do
      @author = FactoryGirl.create(:user, :author)
      allow(authentication).to receive(:current_user).and_return(@author)
      expect(authentication.current_user.role).to eql @author.role      
    end

    it "logs in institution_admin" do
      @institution_admin = FactoryGirl.create(:user, :institution_admin)
      allow(authentication).to receive(:current_user).and_return(@institution_admin)
      expect(authentication.current_user.role).to eql @institution_admin.role      
    end
  end

  describe "#authenticate_with_token" do
    before do
      @user = FactoryGirl.create :user

      allow(authentication).to receive(:current_user).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).and_return({"errors" => "Not authenticated"}.to_json)      
      allow(authentication).to receive(:response).and_return(response)
    end

    it "render a json error message" do
      response
      expect(json_response[:errors]).to eql "Not authenticated"
    end

    it { should respond_with 401 }
  end

  describe "#user_signed_in?" do
    context "when there is a user on 'session'" do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user).and_return(@user)
      end

      it { should be_user_signed_in }
    end

    context "when there is no user on 'session'" do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user).and_return(nil)        
      end

      it { should_not be_user_signed_in }
    end
  end
end
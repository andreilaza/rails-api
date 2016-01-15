require 'spec_helper'

RSpec.describe Api::V1::ChaptersController, type: :controller do
  # describe "GET #index" do
  #   before(:each) do
  #     4.times { FactoryGirl.create :chapter }
  #     get :index
  #   end

  #   it "returns 4 chapters from the database" do
  #     chapter_response = json_response
  #     chapter_response.each do |chapter|
  #       expect(chapter[:title]).to eql "Chapter I"
  #     end      
  #   end

  #   it { should respond_with 200 }
    
  # end

  # describe "GET #show" do
  #   before(:each) do
  #     @chapter = FactoryGirl.create :chapter
  #     get :show, id: @chapter.id
  #   end

  #   it "returns the information about an chapter" do
  #     chapter_response = json_response      
  #     expect(chapter_response[:title]).to eql @chapter.title
  #   end

  #   it { should respond_with 200 }
  # end

  describe "PUT #update && DELETE #destroy && Add-List Sections - author" do
    before(:each) do
      @user = FactoryGirl.create(:user, :author)
      api_authorization_header @user.auth_token      
      @course = FactoryGirl.create :course
      @course_institution = FactoryGirl.create :course_institution, course_id: @course.id, institution_id: @user.institution[:id]      
      @chapter = FactoryGirl.create(:chapter, course_id: @course.id)          
    end

    describe "PUT #update" do
      before(:each) do        
        put :update, { id: @chapter.id, title: "New title"}
      end

      it "renders the json representation for the updated chapter" do
        chapter_response = json_response
        expect(chapter_response[:title]).to eql "New title"
      end

      it { should respond_with 200 }
    end

    describe "DELETE #destroy" do
      before(:each) do        
        delete :destroy, { id: @chapter.id }
      end

      it { should respond_with 204 }
    end

    describe "POST #add_section" do
      before(:each) do
        post :add_section, { id: @chapter.id, title: "Section title", description: "Description", section_type: 1}
      end

      it "returns the created section" do
        chapter_response = json_response
        expect(chapter_response[:title]).to eql "Section title"
      end

      it { should respond_with 201 }

      describe "GET #list_sections" do
        before(:each) do
          get :list_sections, { id: @chapter.id }
        end

        it "returns the sections in this chapter" do
          chapter_response = json_response
          chapter_response.each do |section|
            expect(section[:title]).to eql "Section title"
          end
        end

        it { should respond_with 201 }
      end
    end
  end
end

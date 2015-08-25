class Api::V1::ChaptersController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    respond_with Chapter.all.to_json
  end

  def show
    respond_with Chapter.find(params[:id])
  end  

  def destroy
    chapter = Chapter.find(params[:id])
    chapter.destroy

    head 204    
  end

  private
    def chapter_params
      params.require(:chapter).permit(:title, :description, :image, :published)
    end
end

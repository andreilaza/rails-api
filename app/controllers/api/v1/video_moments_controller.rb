class Api::V1::VideoMomentsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  private
    ### AUTHOR METHODS ###    
    def author_index
      respond_with VideoMoment.all
    end

    def author_show
      video_moment = VideoMoment.find(params[:id])

      if video_moment
        render json: video_moment, status: 200, root: false
      else
        render json: { errors: video_moment.errors }, status: 404
      end
    end 
    
    def author_create
      video_moment = VideoMoment.new(video_moment_params)    
      
      if video_moment.save        
        render json: video_moment, status: 201, root: false
      else
        render json: { errors: video_moment.errors }, status: 422
      end
    end

    def author_update
      video_moment = VideoMoment.find(params[:id])
    
      if video_moment.update(video_moment_params)
        render json: video_moment, status: 200, root: false
      else
        render json: { errors: video_moment.errors }, status: 422
      end      
    end

    def author_destroy
      video_moment = VideoMoment.find(params[:id])
      video_moment.destroy

      head 204    
    end

    ### GENERAL METHODS ###
    def video_moment_params
      params.permit(:title, :asset_id, :time)
    end
end

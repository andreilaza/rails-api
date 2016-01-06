class Api::V1::AnnouncementsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  private
    ### ADMIN METHODS ###   
    def admin_index
      announcements = Announcement.all

      if announcements
        render json: announcements, status: 201, root: false
      else
        render json: { errors: announcements.errors }, status: 422
      end
    end

    def admin_create
      announcement = Announcement.new(announcement_params)      
      announcement.user_id = current_user.id
      if announcement.save        
        render json: announcement, status: 201, root: false
      else
        render json: { errors: announcement.errors }, status: 422
      end
    end

    def admin_update
      announcement = Announcement.find(params[:id])
      announcement.user_id = current_user.id
      if announcement.update(announcement_params)        
        render json: announcement, status: 200, root: false
      else
        render json: { errors: announcement.errors }, status: 422
      end   
    end

    def admin_show
      announcement = Announcement.find(params[:id])

      if announcement
        render json: announcement, status: 201, root: false
      else
        render json: { errors: announcement.errors }, status: 422
      end
    end

    def admin_destroy
      announcement = Announcement.find(params[:id])
      announcement.destroy

      head 204    
    end

    def announcement_params
      params.permit(:announcement)
    end
end

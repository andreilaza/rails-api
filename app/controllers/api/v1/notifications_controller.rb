class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json  

  private  
    def estudent_index
      notifications = Notification.joins(:user_notification).where('user_notifications.user_id' => current_user.id).uniq.all

      if notifications
        render json: notifications, status: 200, root: false
      else
        render json: { errors: notifications.errors }, status: 404
      end
    end

    def estudent_show
      notification = Notification.joins(:user_notification).where('user_notifications.user_id' => current_user.id, 'user_notifications.notification_id' => params[:id]).first

      if notification
        render json: notification, status: 200, root: false
      else
        render json: { errors: notification.errors }, status: 404
      end
    end

    def estudent_update
      user_notification = UserNotification.where('user_id' => current_user.id, 'notification_id' => params[:id]).first
      user_notification.status = params[:seen]
      user_notification.save

      estudent_show
    end

    def notification_params
      params.permit(:seen)
    end
end

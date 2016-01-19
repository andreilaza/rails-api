class Api::V1::StudentVideoSnapshotsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  private
    ### ESTUDENT METHODS ###    
    def estudent_create
      snapshot = StudentVideoSnapshot.where(section_id: params[:section_id], user_id: current_user.id).first
      
      if snapshot
        snapshot.time = params[:time]
      else
        snapshot = StudentVideoSnapshot.new(snapshot_params)
        snapshot.user_id = current_user.id  
      end
      
      if snapshot.save        
        render json: snapshot, status: 201, root: false
      else
        render json: { errors: snapshot.errors }, status: 422
      end
    end

    def estudent_update
      snapshot = StudentVideoSnapshot.find(params[:id])
      
      if snapshot.update(snapshot_params)
        render json: snapshot, status: 200, root: false
      else
        render json: { errors: snapshot.errors }, status: 422
      end 
    end

    def estudent_destroy
      snapshot = StudentVideoSnapshot.find(params[:id])
      snapshot.destroy

      head 204    
    end

    ### GENERAL METHODS ###
    def snapshot_params
      params.permit(:user_id, :section_id, :time)
    end
end

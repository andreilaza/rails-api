class Api::V1::SectionSettingsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  private
    def author_show
      setting =  SectionSetting.find(params[:id])

      if setting
        render json: setting, status: 200, root: false
      else
        render json: { errors: setting.errors }, status: 404
      end
    end

    def author_update
      setting =  SectionSetting.where(id: params[:id], handle: params[:handle]).first
      setting.value = params[:value]
      if setting.save
        render json: setting, status: 200, root: false
      else
        render json: { errors: setting.errors }, status: 422
      end
    end

    def author_destroy
      setting =  SectionSetting.find(params[:id])
      setting.destroy

      head 204    
    end
end
class Api::V1::InstitutionsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def show
    respond_with Institution.find(params[:id])
  end
end

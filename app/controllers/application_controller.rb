class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  serialization_scope :current_user
  # before_filter :set_headers 
  include Authenticable

  def add_asset(params)

    asset = Asset.where(:entity_id => params['entity_id'], :entity_type => params['entity_type'], :definition => params['definition']).first

    if asset      
      asset['path'] = params['path']
      asset.save
    else      
      asset = Asset.new(params)
      asset.save
    end

    asset
  end

  def serialize_section(section)
    serializer = CustomSectionSerializer.new(section, scope: serialization_scope, root: false).as_json
  end
end
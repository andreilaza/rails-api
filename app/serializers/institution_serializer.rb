class InstitutionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :url, :logo

  def logo
    asset = Asset.where('entity_id' => object.id, 'entity_type' => 'institution', 'definition' => 'logo').first
    
    if asset
      asset.path
    else
      nil
    end
  end
end

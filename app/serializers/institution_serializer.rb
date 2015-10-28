class InstitutionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :url, :logo, :has_institution_admin

  def logo
    asset = Asset.where('entity_id' => object.id, 'entity_type' => 'institution', 'definition' => 'logo').first
    
    if asset
      asset.path
    else
      nil
    end
  end

  def filter(keys)
    if scope.role == User::ROLES[:admin]
      keys
    else
      keys - [:has_institution_admin]
    end
  end

  def has_institution_admin
    institution_admin = Institution.joins(:institution_users, :users).where('institutions.id' => object.id, 'users.role' => User::ROLES[:institution_admin]).first

    if institution_admin
      true
    else
      false
    end
  end
end

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role, :first_name, :last_name, :avatar, :institutions, :created_at, :updated_at

  def role    
    if object.role == 1
      'admin'
    elsif object.role == 2
      'student'
    elsif object.role == 3
      'author'
    elsif object.role == 4
      'institution_admin'
    end

  end
  
  def avatar
    asset = Asset.where('entity_id' => object.id, 'entity_type' => 'user', 'definition' => 'avatar').first
    
    if asset
      asset.path
    else
      nil
    end
  end
end

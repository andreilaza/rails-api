class InstitutionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :url, :logo, :has_institution_admin, :slug

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
    elsif scope.role == User::ROLES[:estudent]
      keys + [:courses] + [:authors]
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

  def courses
    response = []
    object.courses.each do |item|
      course = CourseSerializer.new(item, root: false)
      response.push(course)
    end
    response
  end

  def authors
    authors = User.select("user_metadata.*, users.id as id, users.first_name, users.last_name, users.email").joins(:user_metadatum, :institution_user, :institution).where('institutions.id' => object.id).all
    authors_response = []
    entry = {}
    authors.each do |author|
      entry = author.as_json
      entry.except!('auth_token')
      entry.except!('role')

      asset = Asset.where('entity_id' => author.id, 'entity_type' => 'user', 'definition' => 'avatar').first
    
      if asset
        entry['avatar'] = asset.path
      else
        entry['avatar'] = nil
      end
      authors_response.push(entry)
    end

    authors_response

  end
end

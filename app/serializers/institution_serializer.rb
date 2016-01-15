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
    courses = Course.joins(:course_institution, :institution).where('institutions.id' => object.id, 'courses.status' => Course::STATUS[:published]).all
    courses_response = []
    entry = {}
    courses.each do |course|

      entry = course.as_json

      asset = Asset.where('entity_id' => course.id, 'entity_type' => 'course', 'definition' => 'cover_image').first
      if asset
        entry['cover_image'] = asset.path
      else
        entry['cover_image'] = nil
      end

      duration = Section.where(course_id: course.id).sum(:duration)
      
      if duration
        entry['duration'] = duration
      else
        entry['duration'] = 0
      end

      questions = Question.where(course_id: course.id).count
      entry['questions'] = questions
            
      user = User.select("user_metadata.*, users.id as id, users.first_name, users.last_name, users.email").joins(:user_metadatum, :author_courses, :courses).where('courses.id' => course.id).first
      
      asset = Asset.where('entity_id' => user.id, 'entity_type' => 'user', 'definition' => 'avatar').first

      user = user.as_json

      if asset
        user['avatar'] = asset.path
      else
        user['avatar'] = nil
      end

      entry['author'] = user

      courses_response.push(entry)
    end

    courses_response

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

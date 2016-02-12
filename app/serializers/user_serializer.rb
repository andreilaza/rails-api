class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :role, :first_name, :last_name, :avatar, :facebook_uid, :facebook, :linkedin, :twitter, :biography, :position, :website, :created_at, :updated_at

  def initialize(object, options = {})
    @object = object
    @options = options
    @root = options[:root]
    @meta = options[:meta]
    @meta_key = options[:meta_key]
    @scope = options[:scope]

    scope_name = options[:scope_name]

    if scope_name && !respond_to?(scope_name)
      self.class.class_eval do
        define_method scope_name, lambda { scope }
      end
    end

    if object.role == User::ROLES[:author] || object.role == User::ROLES[:institution_admin]
      @author_metadata = author_metadata
    end
    
  end

  def filter(keys)
    if object.role != User::ROLES[:author] && object.role != User::ROLES[:institution_admin]
      keys - [:facebook] - [:linkedin] - [:twitter] - [:biography] - [:position] - [:website] + [:total_video_time] + [:videos_seen] + [:correct_questions] + [:incorrect_questions]
    elsif (object.role == User::ROLES[:author] || object.role == User::ROLES[:institution_admin]) && scope.role == User::ROLES[:estudent]
      keys + [:institution] + [:courses] - [:role]
    else
      keys
    end
  end

  def institution
    institution = Institution.joins(:institution_users, :users).where('users.id' => object.id).first

    asset = Asset.where('entity_id' => institution.id, 'entity_type' => 'institution', 'definition' => 'logo').first

    institution = institution.as_json

    if asset
      institution['logo'] = asset.path
    else
      institution['logo'] = nil
    end

    institution
  end

  def courses  
    response = []
    object.courses.each do |item|
      course = CourseSerializer.new(item, root: false, scope: scope)
      response.push(course)
    end
    response
  
  end

  def role    
    if object.role == User::ROLES[:admin]
      'admin'
    elsif object.role == User::ROLES[:estudent]
      'estudent'
    elsif object.role == User::ROLES[:author]
      'author'
    elsif object.role == User::ROLES[:institution_admin]
      'institution_admin'
    end
  end

  def total_video_time
    completed_sections = Section.joins(:students_sections).where("students_sections.user_id = ? AND students_sections.completed = 1 AND sections.section_type = ?", object.id, Section::TYPE[:content]).sum(:duration)
    snapshots = Section.joins(:student_video_snapshot).where("student_video_snapshots.user_id = ?", object.id).sum(:time)
    completed_sections + snapshots
  end

  def videos_seen
    Section.joins(:students_sections).where("students_sections.user_id = ? AND students_sections.completed = 1 AND sections.section_type = ?", object.id, Section::TYPE[:content]).count
  end

  def correct_questions
    StudentsQuestion.uniq.where("user_id = ? AND completed = 1", object.id).count
  end

  def incorrect_questions
    StudentsQuestion.uniq.where("user_id = ? AND finished = 1 AND completed = 0", object.id).count
  end
  
  def facebook
    @author_metadata.facebook
  end

  def linkedin
    @author_metadata.linkedin
  end

  def twitter
    @author_metadata.twitter
  end

  def biography
    @author_metadata.biography
  end

  def position
    @author_metadata.position
  end

  def website
    @author_metadata.website
  end

  def avatar
    asset = Asset.where('entity_id' => object.id, 'entity_type' => 'user', 'definition' => 'avatar').first
    
    if asset
      asset.path
    else
      nil
    end
  end

  private
    def author_metadata
      author_metadata = UserMetadatum.where(user_id: object.id).first
    end
end

class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :second_description, :slug, :published, :started, :progress, :completed, :duration, :institution, :cover_image, :author, :questions, :domain, :category, :teaser, :video_moments, :video_snapshot, :subtitles

  has_many :chapters

  def filter(keys)
    if scope.role == User::ROLES[:estudent]
      keys
    else
      keys - [:completed] - [:institution] - [:progress] - [:started] - [:author]
    end
  end

  def completed
    students_course = StudentsCourse.where(user_id: scope.id, course_id: object.id).first

    if students_course
      students_course.completed
    else
      false
    end
  end

  def started
    students_course = StudentsCourse.where(user_id: scope.id, course_id: object.id).first

    if students_course
      true
    else
      false
    end
  end

  def institution
    institution = Institution.joins(:course_institution, :courses).where('courses.id' => object.id).first
    asset = Asset.where('entity_id' => institution.id, 'entity_type' => 'institution', 'definition' => 'logo').first

    institution = institution.as_json

    if asset
      institution['logo'] = asset.path
    else
      institution['logo'] = nil
    end

    institution
  end

  def progress
    students_sections = StudentsSection.where(user_id: scope.id, course_id: object.id).count
    completed = StudentsSection.where(user_id: scope.id, course_id: object.id, completed: true).count

    if students_sections > 0
      progress = completed * 100 / students_sections
    else
      0
    end
  end

  def cover_image
    asset = Asset.where('entity_id' => object.id, 'entity_type' => 'course', 'definition' => 'cover_image').first
    
    if asset
      asset.path
    else
      nil
    end
  end

  def duration    
    duration = Section.where(course_id: object.id).sum(:duration)

    if duration
      duration
    else
      0
    end
  end

  def author
    user = User.select("user_metadata.*, users.id as id, users.first_name, users.last_name, users.email").joins(:user_metadatum, :course_institutions, :courses).where('courses.id' => object.id).first
    asset = Asset.where('entity_id' => user.id, 'entity_type' => 'user', 'definition' => 'avatar').first

    user = user.as_json

    if asset
      user['avatar'] = asset.path
    else
      user['avatar'] = nil
    end

    user
  end

  def teaser
    assets = Asset.where('entity_id' => object.id, 'entity_type' => 'course', 'definition' => 'teaser').all    
  end

  def video_moments
    video_moments = VideoMoment.joins(:asset).where('assets.entity_id' => object.id, 'assets.entity_type' => 'course', 'assets.definition' => 'teaser').all
  end

  def subtitles
    asset = Asset.where('entity_id' => object.id, 'entity_type' => 'course', 'definition' => 'subtitles').first
    
    if asset
      asset
    else
      nil
    end  

  end

  def video_snapshot
    snapshot = StudentVideoSnapshot.joins(:asset).where('assets.entity_id' => object.id, 'assets.entity_type' => 'course', 'assets.definition' => 'teaser', 'student_video_snapshots.user_id' => scope.id).first
  end

  def questions
    questions = Question.where(course_id: object.id).count
  end

  def category
    category = Category.joins(:category_courses, :courses).where('courses.id' => object.id).first
  end

  def domain
    domain = Domain.joins(:category_courses, :courses).where('courses.id' => object.id).first
  end
end
class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :published, :started, :progress, :completed, :duration, :institution, :cover_image

  has_many :chapters

  def filter(keys)
    if scope.role == User::ROLES[:estudent]
      keys
    else
      keys - [:completed] - [:institution] - [:progress] - [:started]
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
    institution  = Institution.joins(:course_institution, :courses).where('courses.id' => object.id).first
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
    chapters = Chapter.where(course_id: object.id).select(:id)
    duration = Section.where(chapter_id: chapters).sum(:duration)

    if duration
      duration
    else
      0
    end
  end
end

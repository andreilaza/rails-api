class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :published, :completed, :institution

  has_many :chapters

  def filter(keys)
    if scope.role == User::ROLES[:estudent]
      keys
    else
      keys - [:completed] - [:institution]
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

  def institution
    institution  = Institution.joins(:course_institution, :courses).where('courses.id' => object.id).first
  end
end

class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :second_description, :bibliography, :keywords, :meta_description, :slug, :favorite, :status, :started, :video_sections, :practice_sections, :progress, :completed, :finished, :duration, :institution, :cover_image, :authors, :questions, :domain, :category, :teaser, :subtitles, :was_published, :dependency

  has_many :chapters

  def filter(keys)
    if scope && scope.role == User::ROLES[:estudent]
      keys + [:total_video_time] + [:videos_seen] + [:correct_questions] + [:incorrect_questions] + [:completed_sections]
    else      
        keys - [:favorite] - [:completed] - [:finished] - [:institution] - [:progress] - [:started]
    end
  end

  def completed_sections
    completed_sections = Section.joins(:students_sections).where("students_sections.user_id = ? AND students_sections.completed = 1 AND sections.section_type = ? AND students_sections.course_id = ?", scope.id, Section::TYPE[:quiz], object.id).count
  end

  def total_video_time
    completed_sections = Section.joins(:students_sections).where("students_sections.user_id = ? AND students_sections.completed = 1 AND sections.section_type = ? AND students_sections.course_id = ?", scope.id, Section::TYPE[:content], object.id).sum(:duration)
    snapshots = Section.joins(:student_video_snapshot).where("student_video_snapshots.user_id = ? AND sections.course_id = ?", scope.id, object.id).sum(:time)
    completed_sections + snapshots
  end

  def videos_seen
    Section.joins(:students_sections).where("students_sections.user_id = ? AND students_sections.completed = 1 AND sections.section_type = ? AND students_sections.course_id = ?", scope.id, Section::TYPE[:content], object.id).count
  end

  def correct_questions
    StudentsQuestion.uniq(:question_id).where("user_id = ? AND course_id = ? AND completed = 1", scope.id, object.id).count(:question_id)
  end

  def incorrect_questions
    StudentsQuestion.uniq(:question_id).where("user_id = ? AND course_id = ? AND finished = 1 AND completed = 0", scope.id, object.id).count(:question_id)
  end

  def completed
    students_course = StudentsCourse.where(user_id: scope.id, course_id: object.id).first

    if students_course
      students_course.completed
    else
      false
    end
  end

  def finished
    students_course = StudentsCourse.where(user_id: scope.id, course_id: object.id).first

    if students_course
      students_course.finished
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

  def video_sections
    sections = Section.where(section_type: Section::TYPE[:content], course_id: object.id).count
  end

  def practice_sections
    sections = Section.where(section_type: Section::TYPE[:quiz], course_id: object.id).count
  end

  def status
    if object.status == Course::STATUS[:published]
      return 'published'
    end

    if object.status == Course::STATUS[:upcoming]
      return 'upcoming'
    end

    if object.status == Course::STATUS[:unpublished]
      return 'unpublished'
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

  def favorite
    favorite = UserFavoriteCourse.where('course_id' => object.id, 'user_id' => scope.id).first
    if favorite
      true
    else
      false
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

  def authors
    users = User.uniq.select("user_metadata.*, users.id as id, users.first_name, users.last_name, users.email").joins(:user_metadatum, :author_courses, :courses).where('courses.id' => object.id).all
    response = []
    users.each do |user|
      asset = Asset.where('entity_id' => user.id, 'entity_type' => 'user', 'definition' => 'avatar').first

      user = user.as_json

      if asset
        user['avatar'] = asset.path
      else
        user['avatar'] = nil
      end

      response.push(user)
    end

    response
  end

  def teaser
    assets = Asset.where('entity_id' => object.id, 'entity_type' => 'course', 'definition' => 'teaser').all    
  end  

  def subtitles
    asset = Asset.where('entity_id' => object.id, 'entity_type' => 'course', 'definition' => 'subtitles').first
    
    if asset
      asset
    else
      nil
    end  

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

  def dependency
    course = Course.where(:id => object.dependency_id).first
    course = course.as_json    

    if course
      users = User.uniq.select("user_metadata.*, users.id as id, users.first_name, users.last_name, users.email").joins(:user_metadatum, :author_courses, :courses).where('courses.id' => object.dependency_id).all
      authors = []
      users.each do |user|
        asset = Asset.where('entity_id' => user.id, 'entity_type' => 'user', 'definition' => 'avatar').first

        user = user.as_json

        if asset
          user['avatar'] = asset.path
        else
          user['avatar'] = nil
        end

        authors.push(user)
      end    
      course[:authors] = authors
      completed = StudentsCourse.where(:course_id => course[:id], :user_id => scope.id).first
      
      if completed
        course[:completed] = completed.completed
      else
        course[:completed] = false
      end
      course
    else
      nil
    end
  end
end
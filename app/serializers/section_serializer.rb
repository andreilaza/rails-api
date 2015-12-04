class SectionSerializer < ActiveModel::Serializer # Used for requests at the course and chapter level.
  attributes :id, :title, :description, :slug, :chapter_id, :section_type, :order, :completed, :duration, :content, :video_moments, :subtitles, :video_snapshot, :questions

  def filter(keys)
    if scope.role == User::ROLES[:estudent]
      keys
    else
      keys - [:completed]
    end
  end

  def completed
    students_section = StudentsSection.where(user_id: scope.id, section_id: object.id).first
    if students_section
      students_section.completed
    else
      false
    end
  end

  def content
    assets = Asset.where('entity_id' => object.id, 'entity_type' => 'section', 'definition' => 'content').all
    
    if assets
      response = []
      assets.each do |asset|
        response.push({
          "id" => asset.id,
          "path" => asset.path,
          "metadata" => asset.metadata
        })
      response
      end
    else
      nil
    end
  end

  def video_moments
    video_moments = VideoMoment.joins(:asset).where('assets.entity_id' => object.id, 'assets.entity_type' => 'section', 'assets.definition' => 'content').all
  end

  def subtitles
    asset = Asset.where('entity_id' => object.id, 'entity_type' => 'section', 'definition' => 'subtitles').first
    
    if asset
      asset.path
    else
      nil
    end  

  end

  def video_snapshot
    snapshot = StudentVideoSnapshot.joins(:asset).where('assets.entity_id' => object.id, 'assets.entity_type' => 'section', 'assets.definition' => 'content', 'student_video_snapshots.user_id' => scope.id).first
  end

  private 
    def questions
      questions = Question.where(section_id: object.id).count
    end
end

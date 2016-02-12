class SectionSerializer < ActiveModel::Serializer # Used for requests at the course and chapter level.
  attributes :id, :title, :description, :slug, :chapter_id, :section_type, :order, :completed, :finished, :duration, :content, :subtitles, :video_snapshot, :questions

  has_many :video_moments

  def filter(keys)
    if scope && scope.role == User::ROLES[:estudent]
      keys
    else
      keys - [:completed] - [:finished] - [:video_snapshot]
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

  def finished
    students_section = StudentsSection.where(user_id: scope.id, section_id: object.id).first
    if students_section
      students_section.finished
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

  def subtitles
    asset = Asset.where('entity_id' => object.id, 'entity_type' => 'section', 'definition' => 'subtitles').first
    
    if asset
      asset
    else
      nil
    end  

  end

  def video_snapshot
    snapshot = StudentVideoSnapshot.where('section_id' => object.id, 'user_id' => scope.id).first
  end

  private 
    def questions
      questions = Question.where(section_id: object.id).count
    end
end

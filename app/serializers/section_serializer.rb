class SectionSerializer < ActiveModel::Serializer # Used for requests at the course and chapter level.
  attributes :id, :title, :description, :chapter_id, :section_type, :order, :completed, :duration, :content  

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
end

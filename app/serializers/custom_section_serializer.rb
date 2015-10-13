class CustomSectionSerializer < ActiveModel::Serializer # Used for requests at the section level.
  attributes :id, :title, :description, :chapter_id, :section_type, :order, :completed, :content

  has_many :questions

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
      end
      response
    else
      nil
    end
  end
end

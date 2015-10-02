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
    asset = Asset.where('entity_id' => object.id, 'entity_type' => 'section', 'definition' => 'content').first
    
    if asset
      asset.path
    else
      nil
    end
  end
end

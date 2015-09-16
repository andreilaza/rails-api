class SectionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :chapter_id, :section_type, :order, :completed

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
end

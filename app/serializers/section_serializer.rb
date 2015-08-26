class SectionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :chapter_id, :section_type
end

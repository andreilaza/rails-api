class ChapterSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :image, :course_id, :order, :slug

  has_many :sections  
end

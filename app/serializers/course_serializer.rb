class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :image, :published

  has_many :chapters
end

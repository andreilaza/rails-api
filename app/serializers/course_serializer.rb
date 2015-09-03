class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :published

  has_many :chapters  
end

class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :image, :published
end

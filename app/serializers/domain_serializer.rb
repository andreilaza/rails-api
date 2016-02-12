class DomainSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :slug
  has_many :categories
end

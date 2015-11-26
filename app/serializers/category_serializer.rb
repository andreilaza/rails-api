class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :domain_id, :slug  
end

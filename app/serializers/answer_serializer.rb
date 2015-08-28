class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :title, :order, :correct
end

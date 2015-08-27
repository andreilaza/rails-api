class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :section_id, :order, :score, :question_type
end

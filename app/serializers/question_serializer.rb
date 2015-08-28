class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :section_id, :order, :score, :question_type

  has_many :answers
end

class QuestionHintSerializer < ActiveModel::Serializer
  attributes :id, :title
  has_one :video_moment  
end

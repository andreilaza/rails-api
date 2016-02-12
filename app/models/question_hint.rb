class QuestionHint < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :question
  belongs_to :video_moment  
end

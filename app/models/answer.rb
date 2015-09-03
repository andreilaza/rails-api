class Answer < ApplicationModel
  validates :title, presence: true
  validates :question_id, presence: true

  belongs_to :question
end

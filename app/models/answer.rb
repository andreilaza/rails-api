class Answer < ActiveRecord::Base
  validates :title, presence: true
  validates :question_id, presence: true

  belongs_to :question
end

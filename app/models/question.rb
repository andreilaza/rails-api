class Question < ApplicationModel
  validates :title, presence: true
  validates :section_id, presence: true

  belongs_to :section

  has_many :answers, dependent: :destroy
end

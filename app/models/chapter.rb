class Chapter < ApplicationModel
  validates :title, presence: true
  validates :course_id, presence: true

  belongs_to :course

  has_many :sections, dependent: :destroy
end

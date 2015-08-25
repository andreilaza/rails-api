class Chapter < ActiveRecord::Base
  validates :title, presence: true
  validates :course_id, presence: true

  belongs_to :course
end

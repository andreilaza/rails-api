class Course < ActiveRecord::Base
  validates :title, presence: true
  
  has_many :course_institution
  has_many :courses, through: :course_institution

  has_many :chapters, dependent: :destroy
end

class Course < ApplicationModel  
  validates :title, presence: true
  
  has_many :course_institution
  has_many :institutions, through: :course_institution

  has_many :chapters, dependent: :destroy

  include Filterable
end

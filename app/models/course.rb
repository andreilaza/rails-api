class Course < ApplicationModel  
  validates :title, presence: true
  
  has_many :course_institutions
  has_many :institutions, through: :course_institutions

  has_many :chapters, dependent: :destroy

  has_many :category_courses
  has_many :categories, through: :category_courses
  has_many :domains, through: :category_courses

  include Filterable
end

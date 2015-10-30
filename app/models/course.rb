class Course < ApplicationModel  
  validates :title, presence: true
  
  has_many :course_institutions
  has_many :institutions, through: :course_institutions

  has_many :chapters, dependent: :destroy

  include Filterable
end

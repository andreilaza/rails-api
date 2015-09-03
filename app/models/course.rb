class Course < ApplicationModel
  validates :title, presence: true
  
  has_many :course_institution
  has_many :courses, through: :course_institution

  has_many :chapters, dependent: :destroy

  attr_accessor :isus  
  # mount_uploader :image, ImageUploader
end

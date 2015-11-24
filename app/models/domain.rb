class Domain < ActiveRecord::Base
  validates :title, presence: true
  has_many :categories, dependent: :destroy

  has_many :category_courses
  has_many :courses, through: :category_courses
end

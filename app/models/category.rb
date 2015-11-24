class Category < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :domain

  has_many :category_courses
  has_many :courses, through: :category_courses  
end

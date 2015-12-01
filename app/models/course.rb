class Course < ApplicationModel  
  include Filterable
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  validates :title, presence: true  

  has_many :course_institutions
  has_many :institutions, through: :course_institutions

  has_many :chapters, dependent: :destroy

  has_many :category_courses
  has_many :categories, through: :category_courses
  has_many :domains, through: :category_courses      

  attr_accessor :clean_title

  def slug_candidates
    [:clean_title]
  end
end
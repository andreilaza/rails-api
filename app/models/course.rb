class Course < ApplicationModel  
  include Filterable
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  validates :title, presence: true  

  has_one :course_institution
  has_one :institution, through: :course_institution

  has_many :author_courses
  has_many :users, through: :author_courses
  
  has_many :chapters, dependent: :destroy

  has_one :category_course
  has_one :category, through: :category_course
  
  has_many :domains, through: :category_courses      

  has_many :notifications, as: :entity

  has_many :user_favorite_courses
  has_many :students_courses
  
  attr_accessor :clean_title
  attr_accessor :category

  def slug_candidates
    [
      :clean_title
    ]
  end

  STATUS = {
    :unpublished => 0,
    :upcoming => 1,
    :published => 2
  }
end
class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  validates :title, presence: true
  belongs_to :domain

  has_many :category_courses
  has_many :courses, through: :category_courses  

  attr_accessor :clean_title

  def slug_candidates
    [:clean_title]
  end
end

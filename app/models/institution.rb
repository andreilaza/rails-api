class Institution < ApplicationModel
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  validates :title, presence: true
  
  has_many :institution_users
  has_many :users, through: :institution_users

  has_many :course_institution
  has_many :courses, through: :course_institution

  attr_accessor :clean_title

  def slug_candidates
    [:clean_title]
  end
end

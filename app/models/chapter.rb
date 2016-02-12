class Chapter < ApplicationModel
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  validates :title, presence: true
  validates :course_id, presence: true

  belongs_to :course

  has_many :sections, dependent: :destroy

  attr_accessor :clean_title
  attr_accessor :category

  def slug_candidates
    [:clean_title]
  end
end

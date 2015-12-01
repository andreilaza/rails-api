class Section < ApplicationModel
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  validates :title, presence: true
  validates :chapter_id, presence: true

  belongs_to :chapter

  has_many :questions, dependent: :destroy

  attr_accessor :clean_title

  def slug_candidates
    [:clean_title]
  end
end

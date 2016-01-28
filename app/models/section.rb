class Section < ApplicationModel
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  validates :title, presence: true
  validates :chapter_id, presence: true

  belongs_to :chapter

  has_many :questions, dependent: :destroy
  has_many :video_moments, dependent: :destroy

  has_many :students_sections

  has_one :student_video_snapshot

  attr_accessor :clean_title

  def slug_candidates
    [:clean_title]
  end

  TYPE = {
    :quiz => 1,
    :content => 2
  }

  SETTING = {
    :required_to_pass => 80
  }
end

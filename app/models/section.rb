class Section < ApplicationModel
  validates :title, presence: true
  validates :chapter_id, presence: true

  belongs_to :chapter

  has_many :questions, dependent: :destroy
end

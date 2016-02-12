class StudentVideoSnapshot < ActiveRecord::Base  
  validates :time, presence: true
  validates :section_id, presence: true

  belongs_to :asset  
end

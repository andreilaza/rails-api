class StudentVideoSnapshot < ActiveRecord::Base  
  validates :time, presence: true
  validates :asset_id, presence: true

  belongs_to :asset  
end

class VideoMoment < ActiveRecord::Base
  validates :time, presence: true
  validates :title, presence: true
  validates :asset_id, presence: true

  belongs_to :asset  
end

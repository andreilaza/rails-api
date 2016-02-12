class VideoMoment < ActiveRecord::Base
  validates :time, presence: true
  validates :title, presence: true
  validates :section_id, presence: true

  belongs_to :section  
end

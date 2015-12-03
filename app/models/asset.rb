class Asset < ApplicationModel
  has_many :video_moments, dependent: :destroy
end

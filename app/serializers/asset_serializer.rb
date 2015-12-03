class AssetSerializer < ActiveModel::Serializer
  attributes :id

  has_many :video_moments
end

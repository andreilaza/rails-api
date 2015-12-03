class VideoMomentSerializer < ActiveModel::Serializer
  attributes :id, :title, :time, :asset_id
end

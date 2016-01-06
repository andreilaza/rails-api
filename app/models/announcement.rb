class Announcement < ActiveRecord::Base
  has_many :notifications, as: :entity
  
  include Wisper::Publisher

  after_create{ |announcement| publish(:deliver_announcement, announcement) }
end

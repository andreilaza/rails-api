class Notification < ActiveRecord::Base
  has_many :user_notification
  belongs_to :entity, polymorphic: true
  TYPE = {
    :system => 0,
    :course => 1    
  }  
end

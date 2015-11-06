class Invitation < ApplicationModel
  validates :email, presence: true

  TYPE = {    
    :one_time => 1,
    :multiple => 2    
  }
end

class WaitingList < ActiveRecord::Base
  validates :email, uniqueness: true
end

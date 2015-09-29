class WaitingList < ActiveRecord::Base
  validates :email, uniqueness: true
  validates :email, presence: true
end

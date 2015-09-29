class Invitation < ApplicationModel
  validates :email, presence: true
end

class Course < ActiveRecord::Base
  validates :title, presence: true
  # has_many :institution_users
  # has_many :users, through: :institution_users
end

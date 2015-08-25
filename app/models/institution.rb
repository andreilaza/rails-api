class Institution < ActiveRecord::Base
  validates :title, presence: true
  
  has_many :institution_users
  has_many :users, through: :institution_users

  has_many :course_institution
  has_many :courses, through: :course_institution
end

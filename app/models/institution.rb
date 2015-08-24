class Institution < ActiveRecord::Base
  validates :title, presence: true  
end

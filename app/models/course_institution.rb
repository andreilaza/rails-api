class CourseInstitution < ApplicationModel
  belongs_to :course
  belongs_to :institution  
  belongs_to :user, :foreign_key => :author_id
end
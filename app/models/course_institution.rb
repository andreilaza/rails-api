class CourseInstitution < ApplicationModel
  belongs_to :course
  belongs_to :institution  
end
class CourseInstitution < ActiveRecord::Base
  belongs_to :course
  belongs_to :institution  
end
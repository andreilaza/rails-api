class ChangePublishedToStatusOnCourse < ActiveRecord::Migration
  def up
    add_column :courses, :status, :integer, default: 0
    courses = Course.all
    courses.each do |course|
      if course.published
        course.status = Course::STATUS[:published]
      else
        course.status = Course::STATUS[:unpublished]
      end
      course.save
    end

    remove_column :courses, :published
  end
  
  def down
    add_column :courses, :published, :boolean, default: false
    courses = Course.all
    courses.each do |course|
      if course.status == Course::STATUS[:published]
        course.published = true
      else
        course.published = false
      end
      course.save
    end
    remove_column :courses, :status
  end  
end

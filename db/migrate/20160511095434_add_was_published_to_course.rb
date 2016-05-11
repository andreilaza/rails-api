class AddWasPublishedToCourse < ActiveRecord::Migration
  def up
    add_column :courses, :was_published, :boolean

    courses = Course.all
    courses.each do |course|
      if course.status = Course::STATUS[:published]
        course.was_published = true
      else
        course.was_published = false
      end

      course.save
    end
  end

  def down
    remove_column :courses, :was_published
  end
end
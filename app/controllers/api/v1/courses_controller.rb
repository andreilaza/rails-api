class Api::V1::CoursesController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    respond_with Course.all.to_json
  end

  def show
    course =  Course.find(params[:id])

    if course
      render json: course, status: 200, location: [:api, course], root: false
    else
      render json: { errors: course.errors }, status: 404
    end
  end

  def create
    course = Course.new(course_params)

    if course.save
      
      course_institution = CourseInstitution.new

      course_institution.course_id = course.id
      course_institution.institution_id = current_user.institution_id

      course_institution.save
      
      render json: course, status: 201, location: [:api, course], root: false
    else
      render json: { errors: course.errors }, status: 422
    end
  end

  def update
    course = Course.find(params[:id])

    if course.update(course_params)
      render json: course, status: 200, location: [:api, course], root: false
    else
      render json: { errors: course.errors }, status: 422
    end

  end

  def destroy
    course = Course.find(params[:id])
    course.destroy

    head 204    
  end

  ## Chapter actions ##

  def add_chapter
    chapter = Chapter.new(chapter_params)
    chapter.course_id = params[:id]

    if chapter.save
      render json: chapter, status: 201, location: [:api, chapter], root: false
    else
      render json: { errors: chapter.errors }, status: 422
    end
  end

  def list_chapters
    course = Course.find(params[:id])
    
    render json: course.chapters.to_json, status: 201, location: [:api, course], root: false
  end

  private
    def course_params
      params.require(:course).permit(:title, :description, :image, :published)
    end

    def chapter_params
      params.require(:course).permit(:title, :description, :image)
    end
end

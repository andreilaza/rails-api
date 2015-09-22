class Api::V1::CoursesController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def admin_index
    courses = Course.joins(:course_institution, :institutions).where('institutions.id' => current_user.institution_id).all

    response = []
    
    courses.each do |course|      
      serializer = serialize_course(course)
      response.push(serializer)
    end

    render json: response, status: 200, root: false
  end

  def estudent_index
    courses = Course.where(:published => true).all
    
    response = []
    
    courses.each do |course|     
      serializer = serialize_course(course)      
      response.push(serializer)
    end

    render json: response, status: 200, root: false
  end
  
  def admin_show
    course =  Course.joins(:course_institution, :institutions).where('institutions.id' => current_user.institution_id).find(params[:id])    

    course = serialize_course(course)

    if course
      render json: course, status: 200, location: [:api, course], root: false
    else
      render json: { errors: course.errors }, status: 404
    end
  end

  def estudent_show
    course =  Course.where(:published => true).find(params[:id])    

    course = serialize_course(course)

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

      if params[:cover_image]
        append_asset(course)
      end

      course = serialize_course(course)

      render json: course, status: 201, location: [:api, course], root: false
    else
      render json: { errors: course.errors }, status: 422
    end
  end

  def update
    course = Course.joins(:course_institution, :institutions).where('institutions.id' => current_user.institution_id).find(params[:id])    
    
    if course.update(course_params)
      if params[:cover_image]
        append_asset(course)
      end

      course = serialize_course(course)
        
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

  def start
    course = Course.find(params[:id])

    if course.published
      create_snapshot(course)
      course = serialize_course(course)
      render json: course, status: 200, location: [:api, course], root: false
    else
      render json: { errors: 'Course not found' }, status: 404
    end    
  end

  ## Chapter actions ##
  def add_chapter
    # Check if admin has permission to access this course
    course_permission = CourseInstitution.where(course_id: params[:id], institution_id: current_user.institution_id).first

    if course_permission
      chapter = Chapter.new(chapter_params)
      chapter.course_id = params[:id]      

      highest_order_chapter = Chapter.order(order: :desc).first
      chapter.order         = highest_order_chapter.order + 1

      if chapter.save
        render json: chapter, status: 201, location: [:api, chapter], root: false
      else
        render json: { errors: chapter.errors }, status: 422
      end
    else
      render json: { errors: 'Course not found' }, status: 404
    end

  end

  def list_chapters
    course = Course.find(params[:id])
    
    render json: course.chapters.order(order: :desc).to_json, status: 201, location: [:api, course], root: false
  end

  private
    def course_params
      params.permit(:title, :description, :published, :file)
    end

    def chapter_params
      params.permit(:title, :description)
    end

    def append_asset(course)
      asset = {
        'entity_id'   => course[:id],
        'entity_type' => 'course',
        'path'        => params[:cover_image],
        'definition'  => 'cover_image'
      }
      add_asset(asset)
    end

    def serialize_course(course)
      serializer = CourseSerializer.new(course, scope: serialization_scope).as_json
      serializer = serializer['course']
      
      assets = Asset.where('entity_id' => course[:id], 'entity_type' => 'course')

      assets.each do |asset|
        serializer[asset['definition']] = asset['path']
      end
      
      if current_user.role == User::ROLES[:estudent]
        students_course = StudentsCourse.where(user_id: current_user.id, course_id: course.id).first

        if students_course
          serializer['started'] = true
        else
          serializer['started'] = false
        end


      end

      serializer
    end

    def create_snapshot(course)
      students_course = StudentsCourse.new()

      students_course.course_id = course.id
      students_course.user_id = current_user.id

      students_course.save

      chapters = Chapter.where(course_id: course.id).order(order: :asc).all

      chapters.each do |chapter|
        sections = Section.where(chapter_id: chapter.id).order(order: :asc).all
        sections.each do |section|
          students_section = StudentsSection.new()

          students_section.user_id = current_user.id
          students_section.course_id = course.id
          students_section.chapter_id = chapter.id
          students_section.section_id = section.id

          students_section.save
        end
      end
    end
end

class Api::V1::CoursesController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    respond_with Course.all.to_json
  end

  def show
    course =  Course.find(params[:id])    

    serializer = CourseSerializer.new(course).as_json    
    serializer = serializer['course']
    
    assets = Asset.where('entity_id' => course[:id], 'entity_type' => 'course')

    assets.each do |asset|
      serializer[asset['definition']] = asset['path']
    end

    if serializer
      render json: serializer, status: 200, location: [:api, course], root: false
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

      serializer = CourseSerializer.new(course).as_json
      serializer = serializer['course']

      if params[:cover_image]      
        asset = {
          'entity_id'   => course[:id],
          'entity_type' => 'course',
          'path'        => params[:cover_image],
          'definition'  => 'cover_image'
        }
        add_asset(asset)
        serializer['cover_image'] = params[:cover_image]
      end      

      render json: serializer, status: 201, location: [:api, course], root: false
    else
      render json: { errors: course.errors }, status: 422
    end
  end

  def update
    course = Course.find(params[:id])    

    if course.update(course_params)
      serializer = CourseSerializer.new(course).as_json
      serializer = serializer['course']

      if params[:cover_image]      
        asset = {
          'entity_id'   => course[:id],
          'entity_type' => 'course',
          'path'        => params[:cover_image],
          'definition'  => 'cover_image'
        }
        add_asset(asset)
        serializer['cover_image'] = params[:cover_image]
      end    
      render json: serializer, status: 200, location: [:api, course], root: false
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

    highest_order_chapter = Chapter.order(order: :desc).first
    chapter.order = highest_order_chapter.order + 1

    if chapter.save
      render json: chapter, status: 201, location: [:api, chapter], root: false
    else
      render json: { errors: chapter.errors }, status: 422
    end
  end

  def list_chapters
    course = Course.find(params[:id])
    
    render json: course.chapters.order(order: :desc).to_json, status: 201, location: [:api, course], root: false
  end

  private
    def course_params
      params.permit(:title, :description, :image, :published, :file)
    end

    def chapter_params
      params.permit(:title, :description, :image)
    end
end

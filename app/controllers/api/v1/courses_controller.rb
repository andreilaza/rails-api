class Api::V1::CoursesController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def start
    send("#{current_user.role_name}_start")
  end  

  def reset
    send("#{current_user.role_name}_reset")
  end

  ## Chapter actions ##
  def add_chapter
    send("#{current_user.role_name}_add_chapter")
  end

  def list_chapters
    send("#{current_user.role_name}_list_chapters")
  end

  def slugify
    send("#{current_user.role_name}_slugify")
  end

  def assets
    send("#{current_user.role_name}_assets")
  end  

  private
    def course_params
      params.permit(:title, :description, :second_description, :published)
    end

    def chapter_params
      params.permit(:title, :description)
    end

    def append_asset(course_id, path, definition, metadata)
      asset = {
        'entity_id'   => course_id,
        'entity_type' => 'course',
        'path'        => path,
        'definition'  => definition,
        'metadata'    => metadata
      }
      add_asset(asset)
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

    def estudent_index
      courses = Course.where(:published => true).all
      
      render json: courses, status: 200, root: false
    end

    def estudent_show
      course =  Course.where(:published => true).find(params[:id])
      
      if course
        render json: course, status: 200, root: false
      else
        render json: { errors: course.errors }, status: 404
      end
    end

    def estudent_start
      course = Course.find(params[:id])

      if course.published
        create_snapshot(course)      
        render json: course, status: 200, root: false
      else
        render json: { errors: 'Course not found' }, status: 404
      end    
    end

    def estudent_reset
      StudentsQuestion.destroy_all(user_id: current_user.id, course_id: params[:id])
      StudentsSection.destroy_all(user_id: current_user.id, course_id: params[:id])
      StudentsCourse.destroy_all(user_id: current_user.id, course_id: params[:id])

      course =  Course.where(:published => true).find(params[:id])
      
      if course
        render json: course, status: 200, root: false
      else
        render json: { errors: course.errors }, status: 404
      end
    end    

    def author_index
      courses = Course.joins(:course_institutions, :institutions).where('institutions.id' => current_user.institution_id).all    

      render json: courses, status: 200, root: false
    end

    def author_show
      course =  Course.joins(:course_institutions, :institutions).where('institutions.id' => current_user.institution_id).find(params[:id])

      if course
        render json: course, status: 200, root: false
      else
        render json: { errors: course.errors }, status: 404
      end
    end

    def author_create
      course = Course.new(course_params)

      if course.save
        
        course_institution = CourseInstitution.new

        course_institution.course_id = course.id
        #TO-DO: Send institution as param if user belongs to multiple institutions        
        course_institution.institution_id = current_user.institution_id
        course_institution.user_id = current_user.id
        course_institution.save

        if params[:category_id]
          category = Category.find(params[:category_id])

          category_course = CategoryCourse.new
          category_course.category_id = params[:category_id]
          category_course.course_id = course.id
          category_course.domain_id = category.domain_id
          
          category_course.save
        end

        if params[:cover_image]
          append_asset(course.id, params[:cover_image], 'cover_image', nil)
        end

        if params[:teaser]
          append_asset(course.id, params[:teaser][:path], 'teaser', params[:teaser][:metadata])
        end

        render json: course, status: 201, root: false
      else
        render json: { errors: course.errors }, status: 422
      end
    end

    def author_update
      course = Course.joins(:course_institutions, :institutions).where('institutions.id' => current_user.institution_id).find(params[:id])    
      
      if course.update(course_params)
        if params[:cover_image]
          append_asset(course.id, params[:cover_image], 'cover_image', nil)
        end

        if params[:teaser]
          append_asset(course.id, params[:teaser][:path], 'teaser', params[:teaser][:metadata])
        end

        if params[:category_id]
          category_course = CategoryCourse.where('course_id' => params[:id]).first

          if category_course
            category_course.category_id = params[:category_id]
          else
            category = Category.find(params[:category_id])
            category_course = CategoryCourse.new
            category_course.course_id = course.id
            category_course.category_id = category.id
            category_course.domain_id = category.domain_id
          end

          category_course.save
        end
          
        render json: course, status: 200, root: false
      else
        render json: { errors: course.errors }, status: 422
      end

    end

    def author_destroy
      course = Course.find(params[:id])
      course.destroy

      head 204    
    end    

    def author_assets
      asset = Asset.find(params[:id])
      asset.destroy

      head 204
    end

    def author_add_chapter
      # Check if admin has permission to access this course
      course_permission = CourseInstitution.where(course_id: params[:id], institution_id: current_user.institution_id).first

      if course_permission
        chapter = Chapter.new(chapter_params)
        chapter.course_id = params[:id]      

        highest_order_chapter = Chapter.order(order: :desc).first
        if highest_order_chapter
          chapter.order = highest_order_chapter.order + 1
        else
          chapter.order = 1
        end

        if chapter.save
          render json: chapter, status: 201, root: false
        else
          render json: { errors: chapter.errors }, status: 422
        end
      else
        render json: { errors: 'Course not found' }, status: 404
      end
    end  

    def author_list_chapters
      course = Course.find(params[:id])
    
      render json: course.chapters.order(order: :desc).to_json, status: 201, root: false
    end  

    def admin_slugify
      courses = Course.all

      courses.each do |course|
        course.slug = change_diacritics(course.title)
        existing = Course.where('slug' => course.slug).first

        if existing
          result = course.slug.split('-')
          last = result.last
          
          render json: is_number?(last), status: 200, root: false
          return

          if is_number?(last) && !last.empty?
            # result.delete(last)
            # last += 1
            # result.push(last)
            # result = result.join('-')
            render json: last, status: 200, root: false
            return

          else
            result = result.join('-')
            result += '-1'
          end

          course.slug = result
        end
        render json: result, status: 200, root: false
        return
        course.save
      end

      # chapters = Chapter.all

      # chapters.each do |chapter|
      #   chapter.slug = change_diacritics(chapter.title)
        
      #   chapter.save
      # end

      # sections = Section.all

      # sections.each do |section|
      #   section.slug = change_diacritics(section.title)
        
      #   section.save
      # end 

      # domains = Domain.all

      # domains.each do |domain|
      #   domain.slug = change_diacritics(domain.title)
      #   domain.slug = check_uniqueness(domain.slug)
      #   domain.save
      # end 

      # categories = Category.all

      # categories.each do |category|
      #   category.slug = change_diacritics(category.title)
      #   category.slug = check_uniqueness(category.slug)
      #   category.save
      # end

      # institutions = Institution.all

      # institutions.each do |institution|
      #   institution.slug = change_diacritics(institution.title)
      #   institution.slug = check_uniqueness(institution.slug)
      #   institution.save
      # end

      head 200
    end

    def change_diacritics(item)

      item.gsub! 'ț', 't'
      item.gsub! 'ă', 'a'
      item.gsub! 'î', 'i'
      item.gsub! 'â', 'a'
      item.gsub! 'ș', 's'

      item.gsub! 'Ț', 'T'
      item.gsub! 'Â', 'A'
      item.gsub! 'Î', 'I'
      item.gsub! 'Ă', 'A'
      item.gsub! 'Ș', 'S'

      item.parameterize
    end

    def is_number?(string)
      true if Float(string) rescue false
    end    
end

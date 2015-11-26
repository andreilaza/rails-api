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

  def temporary_slugify
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
      course =  Course.where(:published => true).find_by("id = ? OR slug = ?", params[:id], params[:id])
      
      if course
        render json: course, status: 200, root: false
      else
        render json: { errors: course.errors }, status: 404
      end
    end

    def estudent_start
      course = Course.find_by("id = ? OR slug = ?", params[:id], params[:id])

      if course.published
        create_snapshot(course)      
        render json: course, status: 200, root: false
      else
        render json: { errors: 'Course not found' }, status: 404
      end    
    end

    def estudent_reset
      course = Course.find_by("id = ? OR slug = ?", params[:id], params[:id])

      StudentsQuestion.destroy_all(user_id: current_user.id, course_id: course.id)
      StudentsSection.destroy_all(user_id: current_user.id, course_id: course.id)
      StudentsCourse.destroy_all(user_id: current_user.id, course_id: course.id)
      
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
      course =  Course.joins(:course_institutions, :institutions).where('institutions.id' => current_user.institution_id).find_by("courses.id = ? OR courses.slug = ?", params[:id], params[:id])

      if course
        render json: course, status: 200, root: false
      else
        render json: { errors: course.errors }, status: 404
      end
    end

    def author_create
      course = Course.new(course_params)

      if course.save
        if params[:title]
          slug_string = slugify(course.title)
          course = check_existing_slug(course, 'course', slug_string)
          course.save
        end
        course_institution = CourseInstitution.new

        course_institution.course_id = course.id
        #TO-DO: Send institution as param if user belongs to multiple institutions        
        course_institution.institution_id = current_user.institution_id
        course_institution.user_id = current_user.id
        course_institution.save

        if params[:category_id]
          category = Category.find_by("id = ? OR slug = ?", params[:category_id], params[:category_id])

          category_course = CategoryCourse.new
          category_course.category_id = category.id
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

        if params[:subtitles]
          append_asset(course.id, params[:subtitles][:path], 'subtitles', params[:subtitles][:metadata])
        end

        render json: course, status: 201, root: false
      else
        render json: { errors: course.errors }, status: 422
      end
    end

    def author_update
      course = Course.joins(:course_institutions, :institutions).where('institutions.id' => current_user.institution_id).find_by("courses.id = ? OR courses.slug = ?", params[:id], params[:id])
      
      if course.update(course_params)
        if params[:cover_image]
          append_asset(course.id, params[:cover_image], 'cover_image', nil)
        end

        if params[:teaser]
          append_asset(course.id, params[:teaser][:path], 'teaser', params[:teaser][:metadata])
        end

        if params[:subtitles]
          append_asset(course.id, params[:subtitles][:path], 'subtitles', params[:subtitles][:metadata])
        end

        if params[:category_id]
          category_course = CategoryCourse.where('course_id' => course.id).first

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

        if params[:title]
          slug_string = slugify(course.title)
          course = check_existing_slug(course, 'course', slug_string)
          course.save
        end
          
        render json: course, status: 200, root: false
      else
        render json: { errors: course.errors }, status: 422
      end

    end

    def author_destroy
      course = Course.find_by("id = ? OR slug = ?", params[:id], params[:id])
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
      course = Course.find_by("id = ? OR slug = ?", params[:id], params[:id])
      course_permission = CourseInstitution.where(course_id: course.id, institution_id: current_user.institution_id).first

      if course_permission
        chapter = Chapter.new(chapter_params)
        chapter.course_id = course.id

        highest_order_chapter = Chapter.order(order: :desc).first
        if highest_order_chapter
          chapter.order = highest_order_chapter.order + 1
        else
          chapter.order = 1
        end

        if chapter.save
          if params[:title]
            slug_string = slugify(chapter.title)
            chapter = check_existing_slug(chapter, 'chapter', slug_string)
            chapter.save
          end
          render json: chapter, status: 201, root: false
        else
          render json: { errors: chapter.errors }, status: 422
        end
      else
        render json: { errors: 'Course not found' }, status: 404
      end
    end  

    def author_list_chapters
      course = Course.find_by("id = ? OR slug = ?", params[:id], params[:id])
    
      render json: course.chapters.order(order: :desc).to_json, status: 201, root: false
    end  

    def admin_slugify
      courses = Course.all

      courses.each do |course|
        slug_string = change_diacritics(course.title)
        existing = Course.where('slug_string' => slug_string).order('occurences' => 'desc').first

        if existing
          course.occurences = existing.occurences + 1
          course.slug_string = slug_string
          course.slug = slug_string + '-' + existing.occurences.to_s
        else
          course.occurences = 1
          course.slug_string = slug_string
          course.slug = slug_string
        end

        course.save
      end

      chapters = Chapter.all

      chapters.each do |chapter|
        slug_string = change_diacritics(chapter.title)
        existing = Chapter.where('slug_string' => slug_string).order('occurences' => 'desc').first
        
        if existing
          chapter.occurences = existing.occurences + 1
          chapter.slug_string = slug_string
          chapter.slug = slug_string + '-' + existing.occurences.to_s
        else
          chapter.occurences = 1
          chapter.slug_string = slug_string
          chapter.slug = slug_string
        end
        
        chapter.save
      end

      sections = Section.all

      sections.each do |section|
        slug_string = change_diacritics(section.title)
        existing = Section.where('slug_string' => slug_string).order('occurences' => 'desc').first
        
        if existing
          section.occurences = existing.occurences + 1
          section.slug_string = slug_string
          section.slug = slug_string + '-' + existing.occurences.to_s
        else
          section.occurences = 1
          section.slug_string = slug_string
          section.slug = slug_string
        end
        
        section.save
      end 

      domains = Domain.all

      domains.each do |domain|
        slug_string = change_diacritics(domain.title)
        existing = Domain.where('slug_string' => slug_string).order('occurences' => 'desc').first
        
        if existing
          domain.occurences = existing.occurences + 1
          domain.slug_string = slug_string
          domain.slug = slug_string + '-' + existing.occurences.to_s
        else
          domain.occurences = 1
          domain.slug_string = slug_string
          domain.slug = slug_string
        end

        domain.save
      end 

      categories = Category.all

      categories.each do |category|
        slug_string = change_diacritics(category.title)
        existing = Category.where('slug_string' => slug_string).order('occurences' => 'desc').first
        
        if existing
          category.occurences = existing.occurences + 1
          category.slug_string = slug_string
          category.slug = slug_string + '-' + existing.occurences.to_s
        else
          category.occurences = 1
          category.slug_string = slug_string
          category.slug = slug_string
        end

        category.save
      end

      institutions = Institution.all

      institutions.each do |institution|
        slug_string = change_diacritics(institution.title)
        existing = Institution.where('slug_string' => slug_string).order('occurences' => 'desc').first
        
        if existing
          institution.occurences = existing.occurences + 1
          institution.slug_string = slug_string
          institution.slug = slug_string + '-' + existing.occurences.to_s
        else
          institution.occurences = 1
          institution.slug_string = slug_string
          institution.slug = slug_string
        end

        institution.save
      end

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
end

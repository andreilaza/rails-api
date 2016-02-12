class Api::V1::CoursesController < ApplicationController
  before_action :authenticate_with_token!, except: [:show, :index, :notify]
  respond_to :json

  ### ROUTE METHODS ###  
  def start
    send("#{current_user.role_name}_start")
  end  

  def reset
    send("#{current_user.role_name}_reset")
  end

  def add_chapter
    send("#{current_user.role_name}_add_chapter")
  end

  def list_chapters
    send("#{current_user.role_name}_list_chapters")
  end

  def list_video_moments
    send("#{current_user.role_name}_list_video_moments")
  end

  def temporary_slugify
    send("#{current_user.role_name}_slugify")
  end

  def assets
    send("#{current_user.role_name}_assets")
  end

  def list_authors
    send("#{current_user.real_role}_list_authors")
  end

  def add_authors
    send("#{current_user.real_role}_add_authors")
  end

  def notify

    if params[:email] && current_user.email.blank? == true
      guest = GuestNotification.new
      guest.email = params[:email]
      guest.course_id = params[:id]
      guest.save
    else
      settings = UserSetting.where(:key => 'course_notification').first

      if !settings
        settings = UserSetting.new
        settings.key = 'course_notification'
        settings.value = true
        settings.user_id = current_user.id
        settings.save
      end
    end

    course = Course.find(params[:id])    

    if course
      render json: course, status: 200, root: false
    else
      render json: { errors: course.errors }, status: 404
    end
  end

  private
    ### AUTHOR METHODS ###
    def author_index
      courses = Course.joins(:course_institution, :institution).where('institutions.id' => current_user.institution_id).all    

      render json: courses, status: 200, root: false
    end

    def author_show
      course =  Course.joins(:course_institution, :institution).where('institutions.id' => current_user.institution_id).find(params[:id])      
      
      if course
        render json: course, status: 200, root: false
      else
        render json: { errors: course.errors }, status: 404
      end
    end

    def author_create
      course = Course.new(course_params)      

      course.friendly_id
      course.slug = nil
      course.clean_title = clean_title(params[:title])
      course.status = set_status(params[:status])

      if params[:category_id]
        category = Category.find(params[:category_id])
        course.category = category.title
      end

      if course.save        
        course_institution = CourseInstitution.new

        course_institution.course_id = course.id        
        course_institution.institution_id = current_user.institution_id
        course_institution.user_id = current_user.id
        course_institution.save
        
        author_course = AuthorCourse.new

        author_course.user_id = current_user.id
        author_course.course_id = course.id
        author_course.save

        if params[:category_id]
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
          append_asset(course.id, params[:subtitles], 'subtitles', nil)
        end

        render json: course, status: 201, root: false
      else
        render json: { errors: course.errors }, status: 422
      end
    end

    def author_update
      course = Course.joins(:course_institution, :institution).where('institutions.id' => current_user.institution_id).find_by("courses.id = ? OR courses.slug = ?", params[:id], params[:id])
      
      course.friendly_id
      course.slug = nil      
      course.clean_title = clean_title(course.title)
      original_status = course.status
      course.status = set_status(params[:status])
      
      if course.update(course_params)
        if params[:cover_image]
          append_asset(course.id, params[:cover_image], 'cover_image', nil)
        end

        if params[:teaser]
          append_asset(course.id, params[:teaser][:path], 'teaser', params[:teaser][:metadata])
        end

        if params[:subtitles]
          append_asset(course.id, params[:subtitles], 'subtitles', nil)
        end
                
        if course.status == Course::STATUS[:published] && original_status != Course::STATUS[:published]
          # Create notification
          notification = Notification.new
          notification.entity_id = course.id          
          notification.notification_type = 1
          notification.message = 'Cursul ' + course.title + ' este acum public.'
          notification.save

          # Notify users that have clicked Notify Me
          users = User.joins(:user_settings).where('user_settings.key' => 'course_notification', 'user_settings.value' => true).all

          users.each do |user|
            user_notification = UserNotification.new
            user_notification.user_id = user.id
            user_notification.notification_id = notification.id
            user_notification.status = 0
            user_notification.save
          end

          # Notify guests
          guests = GuestNotification.where(:course_id => course.id).all

          guests.each do |guest|
            # Send email to guest.email
            UserMailer.new_course(guest.email, course).deliver
            guest.notification_id = notification.id
            guest.save
          end
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
      # Check if author has permission to access this course
      course = Course.find(params[:id])
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

        chapter.friendly_id
        chapter.slug = nil
        chapter.clean_title = clean_title(params[:title])

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

    def author_list_video_moments
      sections = Section.where('course_id' => params[:id])

      if sections
        render json: sections, status: 200, root: false
      else
        render json: { errors: sections.errors }, status: 404
      end
    end

    ### ESTUDENT METHODS ###
    def estudent_index
      courses = Course.where("status = ? OR status = ?",Course::STATUS[:published], Course::STATUS[:upcoming]).all
      
      render json: courses, status: 200, root: false
    end

    def estudent_show
      course =  Course.where("status = ? OR status = ?",Course::STATUS[:published], Course::STATUS[:upcoming]).find(params[:id])
      
      if course
        render json: course, status: 200, root: false
      else
        render json: { errors: course.errors }, status: 404
      end
    end

    def estudent_update   
      favorite_course = UserFavoriteCourse.where('course_id' => params[:id], 'user_id' => current_user.id).first   
      if params[:favorite]        
        if !favorite_course
          favorite_course = UserFavoriteCourse.new()
          favorite_course.user_id = current_user.id
          favorite_course.course_id = params[:id]
          favorite_course.save
        end        
      else
        if favorite_course
          favorite_course.destroy
        end
      end

      estudent_show

    end

    def estudent_start
      course = Course.find(params[:id])

      if course.status == Course::STATUS[:published]
        create_snapshot(course)      
        render json: course, status: 200, root: false
      else
        render json: { errors: 'Course not found' }, status: 404
      end    
    end

    def estudent_reset
      course = Course.find(params[:id])

      StudentsQuestion.destroy_all(user_id: current_user.id, course_id: course.id)
      StudentsSection.destroy_all(user_id: current_user.id, course_id: course.id)
      StudentsCourse.destroy_all(user_id: current_user.id, course_id: course.id)
      
      if course
        render json: course, status: 200, root: false
      else
        render json: { errors: course.errors }, status: 404
      end
    end
    
    ### GUEST METHODS ###
    def guest_index
      estudent_index
    end

    def guest_show
      estudent_show
    end

    ### INSTITUTION ADMIN METHODS ###
    def institution_admin_list_authors
      authors = User.uniq.joins(:author_courses, :courses).where('courses.id' => params[:id]).all

      if authors
        render json: authors, status: 200, root: false
      else
        render json: { errors: authors.errors }, status: 404
      end
    end

    def institution_admin_add_authors
      authors = User.uniq.select(:id).joins(:author_courses, :courses).where('courses.id' => params[:id]).all

      ids = []

      authors.each do |author|
        ids.push(author.id)
      end

      to_add = params[:authors] - ids
      to_delete = ids - params[:authors]
      
      if to_add
        to_add.each do |author_id|
          author = AuthorCourse.new
          author.course_id = params[:id]
          author.user_id = author_id
          author.save
        end
      end

      if to_delete
        to_delete.each do |author_id|
          author = AuthorCourse.where('user_id' => author_id, 'course_id' => params[:id]).first          
          author.destroy
        end
      end

      institution_admin_list_authors

    end

    ### GENERAL METHODS ###
    def course_params
      params.permit(:title, :description, :second_description)
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

    def set_status(status)
      if status == 'published'
        return Course::STATUS[:published]
      end

      if status == 'upcoming'
        return Course::STATUS[:upcoming]
      end

      if status == 'unpublished'
        return Course::STATUS[:unpublished]
      end
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

          questions = Question.where(section_id: section.id).order(order: :asc).all
          questions.each do |question|
            students_question = StudentsQuestion.new()

            students_question.course_id = course.id
            students_question.user_id = current_user.id
            students_question.section_id = section.id
            students_question.question_id = question.id
            students_question.score = question.score
            students_question.try = 1
            students_question.save
          end
        end
      end
    end    

    def admin_slugify
      courses = Course.all

      courses.each do |course|
        course.slug = nil
        course_clean = course.clone
        course.clean_title = clean_title(course_clean.title)
        course.save
      end

      chapters = Chapter.all

      chapters.each do |chapter|
        chapter.slug = nil
        chapter_clean = chapter.clone
        chapter.clean_title = clean_title(chapter_clean.title)
        chapter.save
      end

      sections = Section.all

      sections.each do |section|
        section.slug = nil
        section_clean = section.clone
        section.clean_title = clean_title(section_clean.title)
        section.save
        
        section.save
      end 

      domains = Domain.all

      domains.each do |domain|
        domain.slug = nil
        domain_clean = domain.clone
        domain.clean_title = clean_title(domain_clean.title)
        domain.save
        
        domain.save
      end 

      categories = Category.all

      categories.each do |category|
        category.slug = nil
        category_clean = category.clone
        category.clean_title = clean_title(category_clean.title)
        category.save
        
        category.save
      end

      institutions = Institution.all

      institutions.each do |institution|
        institution.slug = nil
        institution_clean = institution.clone
        institution.clean_title = clean_title(institution_clean.title)
        institution.save
        
        institution.save
      end

      head 200
    end    
end

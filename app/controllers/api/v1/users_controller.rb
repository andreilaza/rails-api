class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy]  
  before_action :restrict_domain, only: [:facebook_check]
  respond_to :json

  def check_username_availability
    user = User.where('username' => params[:username]).first
    if user

      render json: false, status: 200, root: false
    else
      render json: true, status: 200, root: false
    end
  end

  def check_email_availability 
    if current_user.role_name == 'guest'
      user = User.where('email' => params[:email]).first
    else
      user = User.where('email = ? AND email != ?', params[:email], current_user.email).first
    end

    if user
      render json: {"response" => true}, status: 200, root: false
    else
      render json: {"response" => false}, status: 404, root: false
    end
  end

  def courses
    send("#{current_user.role_name}_courses")
  end

  def facebook_check
    user = User.find_by(facebook_uid: params[:facebook_uid])
    if user      
      return_user(user)
    else
      existing_user = User.find_by(email: params[:email])      
      if existing_user
        existing_user.facebook_uid = params[:facebook_uid]
        return_user(existing_user)
      else
        render json: {'error' => 'User not found.'}, status: 404
      end      
    end
  end

  def return_user(user)
    sign_in user
    token = UserAuthenticationToken.new
    user.user_authentication_tokens << token            
    user.auth_token = token.token
    user.save 
    output = build_output(user)
    render json: output, status: 200, root: false   
  end

  def admin_show
    user = User.find(params[:id])

    if user
      render json: user, status: 201, root: false
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def institution_admin_show
    admin_show
  end

  def author_show
    if current_user.real_role == 'institution_admin'
      admin_show
    elsif current_user.id.to_s == params[:id].to_s
      admin_show
    else
      render json: {'error' => 'User not found.'}, status: 404      
    end
  end

  def estudent_show
    user = User.find(params[:id])

    if user
      render json: user, status: 201, root: false
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def estudent_courses
    favorite_courses = Course.select(:course_id).joins(:user_favorite_courses).where("user_favorite_courses.user_id = ?", params[:id]).all

    students_courses = Course.select(:course_id).joins(:students_courses).where("students_courses.user_id = ?", params[:id]).all

    courses_ids = []

    favorite_courses.each do |fc|
      courses_ids.push(fc.course_id)
    end

    students_courses.each do |sc|
      courses_ids.push(sc.course_id)
    end

    courses = Course.uniq.find(courses_ids)

    # courses = Course.joins("INNER JOIN user_favorite_courses ON user_favorite_courses.course_id = courses.id AND user_favorite_courses.user_id = #{params[:id]} INNER JOIN students_courses ON students_courses.course_id = courses.id AND students_courses.user_id = #{params[:id]}").all

    if courses
      render json: courses, status: 201, root: false
    else
      render json: { errors: courses.errors }, status: 422
    end
  end

  def guest_show
    estudent_show
  end

  def create
    user = User.new(user_params)

    if user.save

      if params[:avatar]
        append_asset(user)
      end

      render json: user, status: 201, root: false
    else
      render json: { errors: user.errors }, status: 422
    end
  end  

  def change_password    
    send("#{current_user.role_name}_change_password")
  end  

  def destroy
    current_user.destroy

    head 204    
  end

  def latest_course
    send("#{current_user.role_name}_latest_course")
  end

  def institution
    send("#{current_user.role_name}_institution")
  end

  def current
    render json: current_user, status: 200, root: false
  end

  private    
    def estudent_update
      user = current_user

      if user.update(user_params)

        if params[:avatar]
          append_asset(user)
        end      
        render json: user, status: 200, root: false
      else
        render json: { errors: user.errors }, status: 422
      end
    end

    def admin_update
      estudent_update
    end
    
    def author_update
      user = current_user

      if user.update(admin_update_params)

        if params[:avatar]
          append_asset(user)
        end

        author_metadata = UserMetadatum.where(user_id: current_user.id).first
        author_metadata.facebook = params[:facebook] if defined? params[:facebook]
        author_metadata.website = params[:website] if defined? params[:website]
        author_metadata.twitter = params[:twitter] if defined? params[:twitter]
        author_metadata.linkedin = params[:linkedin] if defined? params[:linkedin]
        author_metadata.biography = params[:biography] if defined? params[:biography]
        author_metadata.position = params[:position] if defined? params[:position]

        author_metadata.save

        render json: user, status: 200, root: false
      else
        render json: { errors: user.errors }, status: 422
      end
    end

    def author_institution
      institution = Institution.joins(:institution_users, :users).where('users.id' => params[:id]).first

      render json: institution, status: 200, root: false
    end

    def user_params
      params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :role, :username, :facebook_uid)
    end

    def admin_update_params
      params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :username, :facebook_uid)
    end

    def append_asset(user)
      asset = {
        'entity_id'   => user[:id],
        'entity_type' => 'user',
        'path'        => params[:avatar],
        'definition'  => 'avatar'
      }      
      add_asset(asset)
    end

    def estudent_latest_course
      students_course = StudentsCourse.where('completed' => false, 'user_id' => current_user.id).order('updated_at DESC').first

      if students_course
        latest_course = Course.where(id: students_course.course_id, status: Course::STATUS[:published]).first

        if !latest_course
          latest_course = {}
        end

      else
        latest_course = {}
      end

      render json: latest_course, status: 200, root: false
    end

    def estudent_change_password
      user = current_user
      
      if user.valid_password? params[:old_password] || params[:password] == params[:password_confirmation]
        user.password = params[:password]        
        token = UserAuthenticationToken.new
        user.user_authentication_tokens << token
        user.auth_token = token.token
        user.save

        render json: user, status: 200, root: false      
      else
        render json: { errors: "Invalid password" }, status: 200, root: false
      end
    end

    def restrict_domain
      render json: { errors: "Not authenticated" },
                status: :unauthorized unless request.remote_ip == ENV['WEB_APP_IP']
    end
end

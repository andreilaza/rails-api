class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy]
  respond_to :json

  def show
    user = User.find(params[:id])

    if user
      render json: user, status: 201, root: false
    else
      render json: { errors: user.errors }, status: 422
    end

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
      params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :role)
    end

    def admin_update_params
      params.permit(:email, :password, :password_confirmation, :first_name, :last_name)
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
        latest_course = Course.where(id: students_course.course_id, published: true).first

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
        user.generate_authentication_token!
        user.save

        output = build_output(user)        

        render json: output.to_json, status: 200, root: false      
      else
        render json: { errors: "Invalid password" }, status: 200, root: false
      end
    end
end

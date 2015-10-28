class Api::V1::InstitutionsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  ## Custom Actions ## 
  def create_users
    send("#{current_user.role_name}_create_users")
  end

  def list_users
    send("#{current_user.role_name}_list_users")
  end

  def list_courses
    send("#{current_user.role_name}_list_courses")
  end
  
  private
    def admin_index
      institutions = Institution.all

      if institutions
        render json: institutions, status: 201, root: false
      else
        render json: { errors: institutions.errors }, status: 422
      end
    end

    def institution_admin_show
      if check_permission
        institution = Institution.find(params[:id])

        if institution
          render json: institution, status: 201, root: false
        else
          render json: { errors: institution.errors }, status: 422
        end
      else
        render json: permission_error, status: 404, root: false
      end
    end

    def admin_create
      institution = Institution.new(institution_params)    
      
      if institution.save
        if params[:logo]
          append_asset(institution)
        end
        render json: institution, status: 201, root: false
      else
        render json: { errors: institution.errors }, status: 422
      end
    end

    def institution_admin_update
      if check_permission

        institution = Institution.find(params[:id])

        if institution.update(institution_params)
          if params[:logo]
            append_asset(institution)
          end
          render json: institution, status: 200, root: false
        else
          render json: { errors: institution.errors }, status: 422
        end
      else
        render json: permission_error, status: 404, root: false
      end
    end

    def admin_destroy
      institution = Institution.find(params[:id])
      institution.destroy

      head 204    
    end

    def institution_admin_create_users
      institution = Institution.find(params[:id])
      user = User.create(user_params)
      
      if user_params[:role] == 'author'
        user.role = 3
      end

      if user_params[:role] == 'institution_admin'
        user.role = 4
      end

      if !user.save
        render json: { errors: user.errors }, status: 422
      elsif !institution.save
        render json: { errors: institution.errors }, status: 422
      else
        institution.institution_users.create(:user_id => user.id)
        render json: user, status: 200, root: false
      end
    end

    def institution_admin_list_users
      institution = Institution.find(params[:id])

      render json: institution.users.to_json(:except => [:auth_token]), status: 200, root: false 
    end

    def author_list_courses
      institution = Institution.find(params[:id])

      render json: institution.courses.to_json, status: 200, root: false   
    end

    def append_asset(institution)
      asset = {
        'entity_id'   => institution[:id],
        'entity_type' => 'institution',
        'path'        => params[:logo],
        'definition'  => 'logo'
      }
      add_asset(asset)
    end

    def institution_params
      params.permit(:title, :description, :url)
    end

    def user_params
      params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :role)
    end

    def check_permission
      institution_user = InstitutionUser.where(institution_id: params[:id], user_id: current_user.id)
      !institution_user.empty?
    end

    def permission_error
      { errors: "Cannot find institution" }
    end    
end

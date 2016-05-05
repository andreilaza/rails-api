class Api::V1::InstitutionsController < ApplicationController
  before_action :authenticate_with_token!, except: [:show, :index]
  respond_to :json

  ## ROUTE METHODS ## 
  def create_users
    send("#{current_user.real_role}_create_users")
  end

  def list_users
    send("#{current_user.real_role}_list_users")
  end

  def list_courses
    send("#{current_user.role_name}_list_courses")
  end

  def index
    send("#{current_user.real_role}_index")
  end

  def show
    send("#{current_user.real_role}_show")
  end

  def create
    send("#{current_user.real_role}_create")
  end

  def update
    send("#{current_user.real_role}_update")
  end

  def destroy
    send("#{current_user.real_role}_destroy")
  end
  
  private
    ### ADMIN METHODS ###   
    def admin_index
      institutions = Institution.all      

      if institutions
        render json: institutions, status: 201, root: false
      else
        render json: { errors: institutions.errors }, status: 422
      end
    end

    def admin_create
      institution = Institution.new(institution_params)    
      
      institution.friendly_id
      institution.slug = nil
      if params[:title]
        institution.clean_title = clean_title(params[:title])
      end

      if institution.save
        if params[:logo]
          append_asset(institution)
        end        

        render json: institution, status: 201, root: false
      else
        render json: { errors: institution.errors }, status: 422
      end
    end

    def admin_update
      institution_admin_update
    end

    def admin_destroy
      institution = Institution.find(params[:id])
      institution.destroy

      head 204    
    end

    def admin_create_users
      if user_params[:role] == 'institution_admin'
        institution = Institution.find(params[:id])
        user = User.create(user_params)
              
        user.role = User::ROLES[:institution_admin]        
        puts user.role
        if !user.save
          render json: { errors: user.errors }, status: 422
        elsif !institution.save
          render json: { errors: institution.errors }, status: 422
        else        
          institution.institution_users.create(:user_id => user.id)

          add_author_metadata(user)          
          render json: user, status: 200, root: false
        end
      else
        render json: {'error' => 'Can only create institution admins!'}, status: 404
      end
    end

    ### AUTHOR METHODS ###
    def author_list_courses
      institution = Institution.find(params[:id])

      render json: institution.courses.to_json, status: 200, root: false
    end

    ### ESTUDENT METHODS ###
    def estudent_index
      admin_index
    end

    def estudent_show
      institution = Institution.find(params[:id])

      render json: institution, status: 200, root: false      
    end

    ### GUEST METHODS ###
    def guest_index
      admin_index
    end

    def guest_show
      estudent_show
    end
    
    ### INSTITUTION ADMIN METHODS ###
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

    def institution_admin_update
      if check_permission

        institution = Institution.find(params[:id])
        
        if params[:title]
          institution.friendly_id
          institution.slug = nil
          institution.clean_title = clean_title(params[:title])
        end

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

    def institution_admin_create_users
      if user_params[:role] == 'author'
        institution = Institution.find(params[:id])
        user = User.create(user_params)
                
        user.role = User::ROLES[:author]               

        if !user.save
          render json: { errors: user.errors }, status: 422
        elsif !institution.save
          render json: { errors: institution.errors }, status: 422
        else
          
          add_author_metadata(user)
          
          institution.institution_users.create(:user_id => user.id)

          user = build_output(user, false)
          render json: user, status: 200, root: false
        end
      else
        render json: {'error' => 'Can only create authors!'}, status: 404
      end
    end

    def institution_admin_list_users      
      users = User.joins(:institution_user, :institution).where('institutions.id' => params[:id]).all      

      render json: users, status: 200, root: false 
    end

    def institution_admin_list_courses
      author_list_courses
    end

    ### GENERAL METHODS ###
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
      params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :role, :username)
    end

    def check_permission
      if current_user.role == User::ROLES[:admin]
        true
      else
        institution = Institution.find(params[:id])
        institution_user = InstitutionUser.where(institution_id: institution.id, user_id: current_user.id)
        !institution_user.empty?
      end
    end    

    def permission_error
      { errors: "Cannot find institution" }
    end

    def add_author_metadata(user)
      author_metadata = UserMetadatum.new()

      author_metadata.user_id = user.id
      author_metadata.facebook = params[:facebook] if defined? params[:facebook]
      author_metadata.website = params[:facebook] if defined? params[:website]
      author_metadata.twitter = params[:twitter] if defined? params[:twitter]
      author_metadata.linkedin = params[:linkedin] if defined? params[:linkedin]
      author_metadata.biography = params[:biography] if defined? params[:biography]
      author_metadata.position = params[:position] if defined? params[:position]

      author_metadata.save
    end
end

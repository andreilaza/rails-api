module Authenticable

  # Devise methods overwrites
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  

    if @current_user.role == User::ROLES[:admin]
      @current_user.real_role = 'admin'
      @current_user.role_name = 'admin'
    end

    if @current_user.role == User::ROLES[:estudent]
      @current_user.role_name = 'estudent'
    end

    if @current_user.role == User::ROLES[:institution_admin]
      add_institution
      @current_user.real_role = 'institution_admin'
      @current_user.role_name = 'author'
    end

    if @current_user.role == User::ROLES[:author]
      add_institution      
      @current_user.role_name = 'author'
    end
        
    @current_user
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated" },
                status: :unauthorized unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end 

  def add_institution
    institution_user = InstitutionUser.where(user_id: @current_user.id).first
    @current_user.institution_id = institution_user.institution_id
  end   
end
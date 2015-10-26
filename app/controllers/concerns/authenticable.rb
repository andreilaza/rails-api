module Authenticable

  # Devise methods overwrites
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])

    if @current_user != nil &&  @current_user.institutions != nil
      @institution_id = nil

      @current_user.institutions.each do | institution |
        @institution_id = institution[:id]
      end    

      @current_user.institution_id = @institution_id

      if @current_user.role == User::ROLES[:admin]
        @current_user.role_name = 'admin'
      end

      if @current_user.role == User::ROLES[:estudent]
        @current_user.role_name = 'estudent'
      end      
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
end
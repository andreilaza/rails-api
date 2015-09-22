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
module Authenticable

  # Devise methods overwrites
  def current_user
    @current_user ||= User.joins(:user_authentication_tokens).where('user_authentication_tokens.token = ? AND user_authentication_tokens.expires_at > ?', request.headers['Authorization'], DateTime.now.beginning_of_day).first
    
    if @current_user.present? && @current_user.id.present?
      if @current_user.role == User::ROLES[:admin]
        @current_user.real_role = 'admin'
        @current_user.role_name = 'admin'
      end

      if @current_user.role == User::ROLES[:estudent]
        @current_user.real_role = 'estudent'
        @current_user.role_name = 'estudent'
      end

      if @current_user.role == User::ROLES[:institution_admin]
        add_institution
        @current_user.real_role = 'institution_admin'
        @current_user.role_name = 'author'
      end

      if @current_user.role == User::ROLES[:author]
        add_institution      
        @current_user.real_role = 'author'
        @current_user.role_name = 'author'
      end
    else
      uat = UserAuthenticationToken.where('token' => request.headers['Authorization']).first
      
      if uat
        uat.destroy
      end      

      @current_user = User.new
      @current_user.role_name = 'guest'      
      @current_user.role = User::ROLES[:estudent]
    end
    
    # @current_user.allow_correct_answer = false 
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

  def set_answer_permission(state, question_id)
    @current_user.allow_correct_answer = state
    @current_user.question_id = question_id
  end
end
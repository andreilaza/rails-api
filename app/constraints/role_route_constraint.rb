class RoleRouteConstraint
  def initialize(role)
    @role = role    
  end

  def matches?(request)
    @user ||= User.find_by(auth_token: request.headers['Authorization'])
    if @user
      @user.role == @role
    else
      false
    end
  end
end
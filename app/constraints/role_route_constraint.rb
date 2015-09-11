class RoleRouteConstraint
  def initialize(role)    
    @role = role
  end

  def matches?(request)
    @user ||= User.find_by(auth_token: request.headers['Authorization'])
    @user.role == @role
  end
end
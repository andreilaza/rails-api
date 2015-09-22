class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role, :created_at, :updated_at

  def role
    # object.role.to_s
    if object.role == 1
      'admin'
    end
    if object.role == 2
      'student'
    end
  end
end

class User < ApplicationModel
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :auth_token, uniqueness: true
  
  attr_accessor :institution_id
  attr_accessor :course_id
  attr_accessor :role_name
  attr_accessor :real_role

  before_create :generate_authentication_token!

  has_many :institution_users
  has_many :institutions, through: :institution_users  
  has_one :author_metadatum
  has_many :course_institutions
  has_many :courses, through: :course_institutions

  ROLES = {
    :owner => 0,
    :admin => 1,
    :estudent => 2,
    :author => 3,
    :institution_admin => 4
  }

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end  
end

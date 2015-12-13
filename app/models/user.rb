class User < ApplicationModel
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable  

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable

  validates_uniqueness_of    :email,     :case_sensitive => false, :allow_blank => true, :if => :email_changed?
  validates_format_of    :email,    :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  validates_presence_of    :password, :on=>:create
  # validates_confirmation_of    :password, :on=>:create
  validates_length_of    :password, :within => Devise.password_length, :allow_blank => true
  
  attr_accessor :institution_id
  attr_accessor :course_id
  attr_accessor :role_name
  attr_accessor :real_role 
  attr_accessor :auth_token  

  has_many :institution_users
  has_many :institutions, through: :institution_users  
  
  has_one :user_metadatum
  
  has_many :author_courses
  has_many :courses, through: :author_courses

  has_many :user_authentication_tokens, dependent: :destroy

  ROLES = {
    :owner => 0,
    :admin => 1,
    :estudent => 2,
    :author => 3,
    :institution_admin => 4
  }  

end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :auth_token, uniqueness: true

  before_create :generate_authentication_token!

  has_many :institution_users
  has_many :institutions, through: :institution_users

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

  # Overwrite the to_json model to exclude the auth_token field
  def to_json(options = {})
    options[:except] ||= [:auth_token]
    super(options)
  end
end

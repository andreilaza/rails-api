class UserAuthenticationToken < ActiveRecord::Base  
  before_create :generate_token
  before_create :set_expiration
  belongs_to :user

  private
    def generate_token
      begin
        self.token = Devise.friendly_token
      end while self.class.exists?(token: token)
    end

    def set_expiration
      self.expires_at = 3.weeks.from_now
    end
end
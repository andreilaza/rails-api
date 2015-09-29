class PasswordMailer < ApplicationMailer
  def reset_password(email, user)
    @user = user
    response = mail( :to => email,
    :subject => 'Reseteaza-ti parola!' )

    response
  end
end

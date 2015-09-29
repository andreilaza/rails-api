class PasswordMailer < ApplicationMailer
  def reset_password(email, new_password)
    @new_password = new_password
    response = mail( :to => email,
    :subject => 'Parola noua pentru estudent.ro' )

    response
  end
end

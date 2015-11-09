class UserMailer < ApplicationMailer
  def send_confirmation(user)
    @user = user

    response = mail( :to => user.email,
    :subject => user.first_name + ' ' + user.last_name + ', bun venit în comunitatea Estudent!' )

    response
  end
end

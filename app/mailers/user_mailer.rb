class UserMailer < ApplicationMailer
  def send_confirmation(user)
    @user = user

    response = mail( :to => user.email,
    :subject => user.first_name + ' ' + user.last_name + ', bun venit în comunitatea Estudent!' )

    response
  end

  def send_feedback(user, feedback, section_title)
    @user = user
    @feedback = feedback
    @section_title = section_title

    mail( :to => ENV["ESTUDENT_EMAIL"],
    :subject => 'Section Feedback' )
  end
end

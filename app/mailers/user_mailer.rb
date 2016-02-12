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
    :subject => 'Feedback la o sectiune' )
  end

  def new_course(email, course)    
    @course = course

    mail( :to => email,
    :subject => 'Cursul tău este disponibil' )
  end
end

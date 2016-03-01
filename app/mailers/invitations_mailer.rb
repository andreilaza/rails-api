class InvitationsMailer < ApplicationMailer
  def send_invitation(email, invitation)
    @invitation = invitation
    response = mail( :to => email,
    :subject => 'Start la învățat pe Estudent!' )

    response
  end

  def notify_staff(email)
    @email = email
    mail( :to => ENV["ESTUDENT_EMAIL"],
    :subject => 'Waiting List Update' )
  end
end

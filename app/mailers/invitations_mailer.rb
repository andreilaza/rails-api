class InvitationsMailer < ApplicationMailer
  def send_invitation(email, invitation)
    @invitation = invitation
    response = mail( :to => email,
    :subject => 'Devino si tu acum estudent!' )

    response
  end

  def notify_staff
    mail( :to => ENV["ESTUDENT_EMAIL"],
    :subject => 'Devino si tu acum estudent!' )
  end
end

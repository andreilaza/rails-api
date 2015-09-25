class InvitationsMailer < ApplicationMailer
  def send_invitation(email)
    response = mail( :to => email,
    :subject => 'Devino si tu acum estudent!' )

    response
  end
end

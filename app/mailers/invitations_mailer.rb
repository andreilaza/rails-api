class InvitationsMailer < ApplicationMailer
  def send_invitation(email, invitation)
    @invitation = invitation
    response = mail( :to => email,
    :subject => 'Devino si tu acum estudent!' )

    response
  end
end

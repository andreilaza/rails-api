class ContactMailer < ApplicationMailer
  def contact_support(contact)
    @name = contact.name
    @email = contact.email
    @message = contact.message

    mail( :to => ENV["ESTUDENT_EMAIL"],
    :subject => 'Mesaj nou de contact' )
  end
end

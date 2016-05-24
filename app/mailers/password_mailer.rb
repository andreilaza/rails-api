class PasswordMailer < ApplicationMailer
  def reset_password(user, new_password)
    @new_password = new_password

    headers "X-SMTPAPI" => {
      "sub" => {
        "%new_password%" => [new_password]        
      },
      "filters" => {
        "templates" => {
          "settings" => {
            "enable" => 1,
            "template_id" => ENV['MAIL_TEMPLATE_RESET_PASSWORD']
          }
        }
      }
    }.to_json

    response = mail( :to => user.email,
    :subject => 'Parola noua pentru estudent.ro' )

    response
  end
end

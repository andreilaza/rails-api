class UserMailer < ApplicationMailer
  def send_confirmation(user)
    @user = user

    headers "X-SMTPAPI" => {
      "filters" => {
        "templates" => {
          "settings" => {
            "enable" => 1,
            "template_id" => ENV['MAIL_TEMPLATE_WELCOME']
          }
        }
      }
    }.to_json

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
    asset = Asset.where('entity_id' => course.id, 'entity_type' => 'course', 'definition' => 'cover_image').first
    cover_image = nil
    if asset
      cover_image = asset.path
    end 

    author = User.uniq.select("user_metadata.*, users.id as id, users.first_name, users.last_name, users.email").joins(:user_metadatum, :author_courses, :courses).where('courses.id' => course.id).first
    if author
      asset = Asset.where('entity_id' => author.id, 'entity_type' => 'user', 'definition' => 'avatar').first
    end

    author_avatar = nil

    if asset
      author_avatar = asset.path
    end

    headers "X-SMTPAPI" => {
      "sub" => {
        "%cover_image%" => [cover_image],
        "%course_slug%" => [course.slug],
        "%course_title%" => [course.title],
        "%author_id%" => [author.id],
        "%author_avatar%" => [author_avatar],
        "%author_name%" => [author.first_name + ' ' + author.last_name],
        "%author_position%" => [author.position]
      },
      "filters" => {
        "templates" => {
          "settings" => {
            "enable" => 1,
            "template_id" => ENV['MAIL_TEMPLATE_COURSE_NOTIFICATION']
          }
        }
      }
    }.to_json
    
    mail( :to => email,
    :subject => 'Cursul tău este disponibil' )
  end
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create({email:"andrei@estudent.ro", password:"password", password_confirmation:"password"})
User.create({email:"stefi@estudent.ro", password:"password", password_confirmation:"password"})

Institution.create({title:"Ctrl-D", image:"http://random.link", description:"Ctrl-D este o organizatie."})

InstitutionUser.create({institution_id:1,user_id:1})
InstitutionUser.create({institution_id:1,user_id:2})

courses = [
  ["Ctrl-D Comunicare Digitala", "Acesta este primul curs Estudent", "http://monkeydrives.com/images/london-12.jpg", false], # id = 1
  ["Ctrl-D Design", "Ceva despre design", "http://monkeydrives.com/images/london-12.jpg", false], # id = 2
  ["Web Development", "Primul curs tech de pe Estudent", "http://monkeydrives.com/images/london-12.jpg", false], # id = 3
  ["Asistenta financiara", "Asistenta financiara? serios?", "http://monkeydrives.com/images/london-12.jpg", false] # id = 4
]

courses.each do |title, description, image, published|
  Course.create(title: title, description: description, image: image, published: published)
end

CourseInstitution.create({course_id:1,institution_id:1})
CourseInstitution.create({course_id:2,institution_id:1})
CourseInstitution.create({course_id:3,institution_id:1})
CourseInstitution.create({course_id:4,institution_id:1})

chapters = [
  ["Despre Comunicare", "Introducere in comunicarea digitala", "http://random.link", 1], # id = 1
  ["Comunicarea Digitala", "Cu ce se mananca?", "http://random.link", 1], # id = 2
  ["Design", "Introducere in design", "http://random.link", 2], # id = 3
  ["Arta vs Tech", "Titlul spune totul", "http://random.link", 2], # id = 4
  ["Algoritmica", "Introducere in algoritmica", "http://random.link", 3], # id = 5
  ["Web development", "Mai multe despre", "http://random.link", 3], # id = 6
  ["Banii", "Si fetele", "http://random.link", 4], # id = 7
  ["Cu ce m-am ales in viata?", "Ce-am baut, ce-am mancat, si pe cine-am strans in brate", "http://random.link", 4] # id = 8
]

chapters.each do |title, description, image, course_id|
  Chapter.create(title: title, description: description, image: image, course_id: course_id)
end

sections = [
  ["Section I", "First Section", 1, 1],
  ["Section II", "Second Section", 1, 1],
  ["Section I", "First Section", 2, 1],
  ["Section II", "Second Section", 2, 1],
  ["Section I", "First Section", 3, 1],
  ["Section II", "Second Section", 3, 1],
  ["Section I", "First Section", 4, 1],
  ["Section II", "Second Section", 4, 1],
  ["Section I", "First Section", 5, 1],
  ["Section II", "Second Section", 5, 1],
  ["Section I", "First Section", 6, 1],
  ["Section II", "Second Section", 6, 1],
  ["Section I", "First Section", 7, 1],
  ["Section II", "Second Section", 7, 1],
  ["Section I", "First Section", 8, 1],
  ["Section II", "Second Section", 8, 1],
]

sections.each do |title, description, chapter_id, section_type|
  Section.create(title: title, description: description, chapter_id: chapter_id, section_type: section_type)
end
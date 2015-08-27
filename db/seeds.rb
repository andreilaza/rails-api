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
  ["Despre Comunicare", "Introducere in comunicarea digitala", "http://random.link", 1, 1], # id = 1
  ["Comunicarea Digitala", "Cu ce se mananca?", "http://random.link", 1, 2], # id = 2
  ["Design", "Introducere in design", "http://random.link", 2, 1], # id = 3
  ["Arta vs Tech", "Titlul spune totul", "http://random.link", 2, 2], # id = 4
  ["Algoritmica", "Introducere in algoritmica", "http://random.link", 3, 1], # id = 5
  ["Web development", "Mai multe despre", "http://random.link", 3, 2], # id = 6
  ["Banii", "Si fetele", "http://random.link", 4, 1], # id = 7
  ["Cu ce m-am ales in viata?", "Ce-am baut, ce-am mancat, si pe cine-am strans in brate", "http://random.link", 4, 2] # id = 8
]

chapters.each do |title, description, image, course_id, order|
  Chapter.create(title: title, description: description, image: image, course_id: course_id, order: order)
end

sections = [
  ["Section I", "First Section", 1, 1, 1], # id = 1
  ["Section II", "Second Section", 1, 1, 2], # id = 2
  ["Section I", "First Section", 2, 1, 1], # id = 3
  ["Section II", "Second Section", 2, 1, 2], # id = 4
  ["Section I", "First Section", 3, 1, 1], # id = 5
  ["Section II", "Second Section", 3, 1, 2], # id = 6
  ["Section I", "First Section", 4, 1, 1], # id = 7
  ["Section II", "Second Section", 4, 1, 2], # id = 8
  ["Section I", "First Section", 5, 1, 1], # id = 9
  ["Section II", "Second Section", 5, 1, 2], # id = 10
  ["Section I", "First Section", 6, 1, 1], # id = 11
  ["Section II", "Second Section", 6, 1, 2], # id = 12
  ["Section I", "First Section", 7, 1, 1], # id = 13
  ["Section II", "Second Section", 7, 1, 2], # id = 14
  ["Section I", "First Section", 8, 1, 1], # id = 15
  ["Section II", "Second Section", 8, 1, 2] # id = 16
]

sections.each do |title, description, chapter_id, section_type, order|
  Section.create(title: title, description: description, chapter_id: chapter_id, section_type: section_type, order: order)
end

questions = [
  ["What is the meaning of life?", 1, 1, 30, 1],
  ["What are you looking at?", 1, 2, 50, 2],
  ["What is the meaning of life?", 2, 1, 30, 1],
  ["What are you looking at?", 2, 2, 50, 2],
  ["What is the meaning of life?", 3, 1, 30, 1],
  ["What are you looking at?", 3, 2, 50, 2],
  ["What is the meaning of life?", 4, 1, 30, 1],
  ["What are you looking at?", 4, 2, 50, 2],
  ["What is the meaning of life?", 5, 1, 30, 1],
  ["What are you looking at?", 5, 2, 50, 2],
  ["What is the meaning of life?", 6, 1, 30, 1],
  ["What are you looking at?", 6, 2, 50, 2],
  ["What is the meaning of life?", 7, 1, 30, 1],
  ["What are you looking at?", 7, 2, 50, 2],
  ["What is the meaning of life?", 8, 1, 30, 1],
  ["What are you looking at?", 8, 2, 50, 2],
  ["What is the meaning of life?", 9, 1, 30, 1],
  ["What are you looking at?", 9, 2, 50, 2],
  ["What is the meaning of life?", 10, 1, 30, 1],
  ["What are you looking at?", 10, 2, 50, 2],
  ["What is the meaning of life?", 11, 1, 30, 1],
  ["What are you looking at?", 11, 2, 50, 2],
  ["What is the meaning of life?", 12, 1, 30, 1],
  ["What are you looking at?", 12, 2, 50, 2],
  ["What is the meaning of life?", 13, 1, 30, 1],
  ["What are you looking at?", 13, 2, 50, 2],
  ["What is the meaning of life?", 14, 1, 30, 1],
  ["What are you looking at?", 14, 2, 50, 2],
  ["What is the meaning of life?", 15, 1, 30, 1],
  ["What are you looking at?", 15, 2, 50, 2],
  ["What is the meaning of life?", 16, 1, 30, 1],
  ["What are you looking at?", 16, 2, 50, 2]
]

questions.each do |title, section_id, order, score, question_type|
  Question.create(title: title, section_id: section_id, order: order, score: score, question_type: question_type)
end
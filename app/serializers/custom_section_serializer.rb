class CustomSectionSerializer < SectionSerializer # Used for requests at the section level.  

  has_many :questions
end

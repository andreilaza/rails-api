class InstitutionUser < ApplicationModel
  belongs_to :institution
  belongs_to :user
end

FactoryGirl.define do
  factory :user do
    email { 'booya@estudent.ro' }
    password "12345678"
    password_confirmation "12345678"
  end

end

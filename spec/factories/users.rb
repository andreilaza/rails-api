FactoryGirl.define do
  factory :user do
    email { 'asd@estudent.ro' }
    password "12345678"
    password_confirmation "12345678"
    role 1
  end
end

FactoryGirl.define do
  factory :user do
    email { 'andrei.test@estudent.ro' }
    password "12345678"
    password_confirmation "12345678"    
    username "username"
    facebook_uid nil    

    trait :admin do
      role User::ROLES[:admin]
      first_name "Stefan"
      last_name "Szakal"
      role_name "admin"
    end

    trait :estudent do
      role User::ROLES[:estudent]
      first_name "Andrei"
      last_name "Laza"
      role_name "estudent"
    end

    trait :author do
      role User::ROLES[:author]
      first_name "Coralia"
      last_name "Sulea"
      role_name "author"
    end

    trait :institution_admin do
      role User::ROLES[:institution_admin]
      first_name "Coralia"
      last_name "Sulea"
      role_name "author"
      real_role "institution_admin"
    end

    trait :guest do
    end
  end
end

FactoryGirl.define do
  factory :user do    
    password "password"
    password_confirmation "password"

    trait :admin do
      email "stefan@estudent.ro"
      role 1
    end

    trait :estudent do
      email "andrei@estudent.ro"
      role 2
    end

    trait :author do
      email "coralia.sulea@e-uvt.ro"
      role 3
    end

    trait :institution_admin do
      email "coralia.sulea@e-uvt.ro"
      role 4
    end
  end
end

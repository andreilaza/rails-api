FactoryGirl.define do
  factory :user do    
    email { 'andrei.test@estudent.ro' }
    password "password"
    password_confirmation "password"    
    username "username"
    facebook_uid "facebook_uid"

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
      association :user_metadatum
      after(:create) do |institution_admin|
        institution_admin.institution = FactoryGirl.create(:institution)
        FactoryGirl.create(:institution_user, user_id: institution_admin.id, institution_id: institution_admin.institution[:id])
      end
    end

    trait :institution_admin do
      role User::ROLES[:institution_admin]
      first_name "Coralia"
      last_name "Sulea"
      role_name "author"
      real_role "institution_admin"
      association :user_metadatum
      after(:create) do |institution_admin|
        institution_admin.institution = FactoryGirl.create(:institution)
      end  
    end

    after(:create) do |user|
      uat = FactoryGirl.create(:user_authentication_token, :user => user)
      user.auth_token = uat.token
    end
  end
end

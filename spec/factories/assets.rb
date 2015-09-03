FactoryGirl.define do
  factory :asset do
    entity_id 1
    entity_type "course"
    path "path/to/s3"
    definition "cover_image"
  end

end

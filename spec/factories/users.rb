FactoryGirl.define do
  factory :user do
    first_name { Faker::Lorem.word }
    last_name { Faker::Lorem.word }
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
  end
end

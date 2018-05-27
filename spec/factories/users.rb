FactoryBot.define do
  factory :user do
    name "foo"
    email "foo@example.com"
    password "123456"
  end

  factory :random_user, class: User do
    name { Faker::Name.first_name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.unique.password(6) }
  end
end

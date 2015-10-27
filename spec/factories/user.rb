FactoryGirl.define do
  factory :user do
    phone { Faker::Number.number(10) }
    password 'password'
    phone_token { Faker::Number.number(4) }
    confirmed_at DateTime.now
  end

  factory :user_credentials, class: User do
    phone { Faker::Number.number(10) }
    password 'password'
  end

  factory :user_with_code, class: User do
    phone { Faker::Number.number(10) }
    password 'password'
    phone_token { Faker::Number.number(4) }
  end
end

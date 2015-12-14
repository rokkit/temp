FactoryGirl.define do
  factory :user do
    name { 'Name' }
    phone { Faker::Number.number(10) }
    password 'password'
    phone_token { Faker::Number.number(4) }
    confirmed_at DateTime.now
    avatar { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'gerb_spb_liberty.svg')) }
    role 0
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

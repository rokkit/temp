FactoryGirl.define do
  factory :skill do
    name 'MyString'
    description 'MyText'
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'gerb_spb_liberty.svg')) }
    role 0
  end
end

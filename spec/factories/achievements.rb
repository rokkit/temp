FactoryGirl.define do
  factory :achievement do
    name "MyString"
description "MyText"
key "MyString"
role 0
image  Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'gerb_spb_liberty.svg'))
  end

end

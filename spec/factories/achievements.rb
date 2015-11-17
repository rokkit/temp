FactoryGirl.define do
  factory :achievement do
    name "MyString"
description "MyText"
key "MyString"
image  Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'gerb_spb_liberty.svg')) 
  end

end

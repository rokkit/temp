FactoryGirl.define do
  factory :lounge do
    title "MyString"
    city nil
    color "MyString"
    blazon { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'gerb_spb_liberty.svg')) }
  end

end

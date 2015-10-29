require 'rails_helper'

RSpec.describe Api::V1::LoungesController, type: :controller do
  before do
    3.times.map { FactoryGirl.create(:lounge) }
  end
  it "should return list of lounges" do
    get :index
    expect_json_types(:array)
    expect(json_body.map {|l| l[:id] }).to include(Lounge.first.id) 
  end
end

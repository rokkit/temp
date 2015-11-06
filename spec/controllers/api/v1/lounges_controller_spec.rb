require 'rails_helper'

RSpec.describe Api::V1::LoungesController, type: :controller do
  render_views
  before do
    3.times.map { FactoryGirl.create(:lounge) }
  end
  describe '#index' do
    it 'returns list of lounges' do
      get :index, format: :json
      expect_json_types(:array)
      expect(json_body.map { |l| l[:id] }).to include(Lounge.first.id)
    end
  end
end

require 'rails_helper'

RSpec.describe Api::V1::TablesController, type: :controller do
  render_views
  describe '#index' do
    let!(:lounge) { FactoryGirl.create :lounge }
    let!(:table) { FactoryGirl.create :table, lounge: lounge }
    context 'when lounge exist' do
      it 'returns tables index' do
          get :index, lounge_id: lounge.id, format: :json
          expect(json_body).to eq [{id: table.id, title: table.title, seats: table.seats}]
      end
    end
  end
end

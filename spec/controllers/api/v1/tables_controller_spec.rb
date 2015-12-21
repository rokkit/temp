require 'rails_helper'

RSpec.describe Api::V1::TablesController, type: :controller do
  render_views
  before do
     allow_any_instance_of(User).to receive(:create_user_ext).and_return('1234')
  end
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

require 'rails_helper'

RSpec.describe Api::V1::ReservationsController, type: :controller do
  render_views
  describe '#create' do
    let(:user) { FactoryGirl.create :user }
    let!(:lounge) { FactoryGirl.create :lounge }
    let!(:table) { FactoryGirl.create :table, lounge: lounge }
    context 'with valid params' do
      it 'creates a record to user' do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in user
        post :create, table_id: table.id, visit_date: DateTime.now + 5.hours
        expect(response).to be_success
      end
    end
    context 'when past visit date present' do
      it 'rejects request' do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in user
        post :create, table_id: table.id, visit_date: DateTime.now - 5.hours
        expect(json_body[:errors]).to be_present
      end
    end
    describe 'meetup creation' do
      let(:user) { FactoryGirl.create :user }
      let(:target_user) { FactoryGirl.create :user }
      let!(:lounge) { FactoryGirl.create :lounge }
      let!(:table) { FactoryGirl.create :table, lounge: lounge }
      before do
        sign_in user
      end
      it "create visit with meetup" do
        post :create, table_id: table.id, meets: [target_user.id], visit_date: DateTime.now + 5.hours
        expect(Reservation.last.meets).to eq [Meet.first]
        expect(response).to be_success
      end
    end
  end

  describe '#load_data' do
    let!(:user) { FactoryGirl.create :user }
    let!(:user2) { FactoryGirl.create :user }
    let!(:lounge) { FactoryGirl.create :lounge }
    let!(:table) { FactoryGirl.create :table, lounge: lounge }
    it 'returns data with lounges, tables and users' do
      sign_in user
      get :load_data, format: :json
      valid_json = {
        lounges: [{
          id: lounge.id, title: lounge.title, tables: [
            {
              id: table.id, title: table.title
            }
          ]
        }],
        users: [{id: user2.id, name: user2.name}]
      }
      expect(json_body).to eq valid_json
    end
  end
end

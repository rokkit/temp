require 'rails_helper'

RSpec.describe Api::V1::ReservationsController, type: :controller do
  render_views
  describe '#create' do
    let(:user) { FactoryGirl.create :user }
    let!(:lounge) { FactoryGirl.create :lounge }
    let!(:table) { FactoryGirl.create :table, lounge: lounge }
    before do
      sign_in user
    end

    context 'simpliest' do
      it 'creates a record to user' do
        post :create, lounge: lounge.id, visit_date: DateTime.now + 5.hours
        expect(json_body[:errors]).to_not be_present
      end
    end

    context 'when time is past' do
      it 'returns error' do
        post :create, lounge: lounge.id, visit_date: '2015-09-02 17:00'
        expect(json_body[:errors][:visit_date]).to eq 'too_late'
      end
    end
    context 'there is not free tables' do
      it 'returns error' do
        Reservation.destroy_all
        post :create, lounge: lounge.id, visit_date: '2016-12-03 18:00'#(DateTime.now + 5.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors]).to_not be_present
        post :create, lounge: lounge.id, visit_date: '2016-12-03 18:00'#(DateTime.now + 5.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors][:visit_date]).to eq 'reserved'
        post :create, lounge: lounge.id, visit_date: '2016-12-03 17:30'
        expect(json_body[:errors][:visit_date]).to eq 'reserved'
      end
      it 'returns error' do
        Reservation.destroy_all
        post :create, lounge: lounge.id, visit_date: '2016-12-03 19:00'#(DateTime.now + 5.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors]).to_not be_present
        post :create, lounge: lounge.id, visit_date: '2016-12-03 18:00'#(DateTime.now + 6.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors][:visit_date]).to eq 'reserved'
      end
    end
    context 'when TWO tables (one is free)' do
      let!(:table) { FactoryGirl.create :table, lounge: lounge }
      let!(:table2) { FactoryGirl.create :table, lounge: lounge }
      it 'create reserv' do
        Reservation.destroy_all
        post :create, lounge: lounge.id, visit_date: '2016-12-03 18:00'#(DateTime.now + 5.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors]).to_not be_present
        post :create, lounge: lounge.id, visit_date: '2016-12-03 18:00'#(DateTime.now + 1.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors]).to_not be_present
      end
      it 'create reserv' do
        Reservation.destroy_all
        post :create, lounge: lounge.id, visit_date: '2016-12-03 20:00'#(DateTime.now + 5.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors]).to_not be_present
        post :create, lounge: lounge.id, visit_date: '2016-12-03 17:00'#(DateTime.now + 1.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors]).to_not be_present
      end
      it 'return error' do
        Reservation.destroy_all; Table.destroy_all; FactoryGirl.create(:table, lounge: lounge); FactoryGirl.create(:table, lounge: lounge)
        post :create, lounge: lounge.id, visit_date: '2016-12-03 17:00'#(DateTime.now + 5.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors]).to_not be_present
        post :create, lounge: lounge.id, visit_date: '2016-12-03 18:00'#(DateTime.now + 1.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors]).to_not be_present
        post :create, lounge: lounge.id, visit_date: '2016-12-03 18:00'#(DateTime.now + 1.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors]).to be_present
      end
    end
    context 'try to reserve on edge of reservations' do
      context 'when ONE table' do
        it 'create reserv' do
          Reservation.destroy_all
          post :create, lounge: lounge.id, visit_date: '2016-12-03 17:00'#(DateTime.now + 2.hours).strftime('%Y-%m-%d %R')
          expect(json_body[:errors]).to_not be_present
          post :create, lounge: lounge.id, visit_date: '2016-12-03 20:00'#(DateTime.now + 6.hours).strftime('%Y-%m-%d %R')
          expect(json_body[:errors]).to_not be_present
        end

        it 'create reserv' do
          Reservation.destroy_all
          post :create, lounge: lounge.id, visit_date: '2016-12-03 20:00'#(DateTime.now + 5.hours).strftime('%Y-%m-%d %R')
          expect(json_body[:errors]).to_not be_present
          post :create, lounge: lounge.id, visit_date: '2016-12-03 17:00'#(DateTime.now + 1.hours).strftime('%Y-%m-%d %R')
          expect(json_body[:errors]).to_not be_present
        end
      end
    end

    describe 'vip users' do
      let!(:user_vip) { FactoryGirl.create :user, role: :vip }
      let!(:user) { FactoryGirl.create :user }
      let!(:lounge) { FactoryGirl.create :lounge }

      context 'when user try to reserve vip table' do
        let!(:table) { FactoryGirl.create :table, vip: true, lounge: lounge }
        context 'when user is vip' do
          before do
            sign_in user_vip
          end
          it 'creates reservation' do
            Reservation.destroy_all; Table.destroy_all; FactoryGirl.create(:table, vip: true, lounge: lounge)
            post :create, lounge: lounge.id, visit_date: '2016-12-03 20:00'
            expect(json_body[:errors]).to_not be_present
          end
        end
        context 'when user not vip' do
          before do
            sign_in user
          end
          it 'returns error' do
            Reservation.destroy_all; Table.destroy_all; FactoryGirl.create(:table, vip: true, lounge: lounge)
            post :create, lounge: lounge.id, visit_date: '2016-12-03 20:00'
            expect(json_body[:errors]).to be_present
          end
        end
      end
    end


      # it 'create record in 1C' do
      #
      #   # let!(:table) { FactoryGirl.create :table }
      #   expect {
      #     post :create, visit_date: DateTime.now + 5.hours
      #   }.to change {
      #     TableReservExt.count
      #   }
      #   expect(response).to be_success
      # end

    # context 'when past visit date present' do
    #   it 'rejects request' do
    #     @request.env['devise.mapping'] = Devise.mappings[:user]
    #     sign_in user
    #     post :create, visit_date: DateTime.now - 5.hours
    #     expect(json_body[:errors]).to be_present
    #   end
    # end
    # describe 'meetup creation' do
    #   let(:user) { FactoryGirl.create :user }
    #   let(:target_user) { FactoryGirl.create :user }
    #   let!(:lounge) { FactoryGirl.create :lounge }
    #   let!(:table) { FactoryGirl.create :table, lounge: lounge }
    #   before do
    #     sign_in user
    #   end
    #   it "create visit with meetup" do
    #     post :create, meets: [target_user.id], visit_date: DateTime.now + 5.hours
    #     expect(Reservation.last.meets).to eq [Meet.first]
    #     expect(response).to be_success
    #   end
    # end
  end
  describe 'time pre validation' do
    context 'when user try to reserve to time is shorter than now + 1 hour' do
      let(:user) { FactoryGirl.create :user }
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in user
      end
      it 'returns error' do
        post :create, visit_date: DateTime.now + 30.minutes
        expect(json_body[:errors]).to be_present
      end
    end
  end

  # describe 'duration and free validations' do
  #   let(:user) { FactoryGirl.create :user }
  #   # let!(:table_ext) { FactoryGirl.create :table_ext }
  #   let!(:reserv_status_ext) { FactoryGirl.create :reserv_status_ext }
  #   before do
  #     @request.env['devise.mapping'] = Devise.mappings[:user]
  #     sign_in user
  #   end
  #   context 'when only one table' do
  #     let!(:table_ext) { FactoryGirl.create :table_ext }
  #     before do
  #       post :create, visit_date: DateTime.now + 3.hours
  #     end
  #     context 'when user try to reserve in time of another reserv' do
  #       it 'reject reservation' do
  #         post :create, visit_date: DateTime.now + 4.hours
  #         expect(json_body[:errors]).to be_present
  #       end
  #     end
  #     context 'when user try to reserve later' do
  #       it 'make a reservation' do
  #         post :create, visit_date: DateTime.now + 7.hours
  #         expect(json_body[:errors]).to_not be_present
  #       end
  #     end
  #   end
    # context 'when two table exists' do
    #   let!(:table_ext) { FactoryGirl.create :table_ext }
    #   let!(:table_ext2) { FactoryGirl.create :table_ext }
    #   before do
    #     post :create, visit_date: DateTime.now + 3.hours
    #   end
    #   context 'when user try to reserve in time of another reserv' do
    #     it 'reject reservation' do
    #       post :create, visit_date: DateTime.now + 4.hours
    #       expect(json_body[:errors]).to_not be_present
    #     end
    #   end
    #   context 'when user try to reserve later' do
    #     it 'make a reservation' do
    #       post :create, visit_date: DateTime.now + 7.hours
    #       expect(json_body[:errors]).to_not be_present
    #
    #       post :create, visit_date: DateTime.now + 7.hours
    #       post :create, visit_date: DateTime.now + 7.hours
    #       expect(json_body[:errors]).to be_present
    #     end
    #   end
    # end
  # end

  # describe '#load_data' do
  #   let!(:user) { FactoryGirl.create :user }
  #   let!(:user2) { FactoryGirl.create :user }
  #   let!(:lounge) { FactoryGirl.create :lounge }
  #   let!(:table) { FactoryGirl.create :table, lounge: lounge }
  #   it 'returns data with lounges, tables and users' do
  #     sign_in user
  #     get :load_data, format: :json
  #     valid_json = {
  #       lounges: [{
  #         id: lounge.id, title: lounge.title, tables: [
  #           {
  #             id: table.id, title: table.title
  #           }
  #         ]
  #       }],
  #       users: [{id: user2.id, name: user2.name}]
  #     }
  #     expect(json_body[:lounges]).to be_present
  #   end
  # end
end

require 'rails_helper'

RSpec.describe Api::V1::ReservationsController, type: :controller do
  render_views
  describe '#create' do
    let(:user) { FactoryGirl.create :user }
    let(:user2) { FactoryGirl.create :user }
    let!(:lounge) { FactoryGirl.create :lounge }
    let!(:table) { FactoryGirl.create :table, lounge: lounge }
    before do
      sign_in user
    end

    context 'простой вариант' do
      it 'creates a record to user' do
        post :create, lounge: lounge.id, visit_date: (DateTime.now + 5.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors]).to_not be_present
      end

    end

    context 'когда время в прошлом' do
      it 'returns error' do
        post :create, lounge: lounge.id, visit_date: '2015-09-02 17:00'
        expect(json_body[:errors][:visit_date]).to eq 'too_late'
      end
    end
    context 'когда нет свободных столов' do
      it 'returns error' do
        Reservation.create! user: user, visit_date: '2016-12-03 18:00', table: table
        # post :create, lounge: lounge.id, visit_date: '2016-12-03 18:00'#(DateTime.now + 5.hours).strftime('%Y-%m-%d %R')
        # expect(json_body[:errors]).to_not be_present
        sign_in user2
        post :create, lounge: lounge.id, visit_date: '2016-12-03 18:30'#(DateTime.now + 5.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors][:visit_date]).to eq 'reserved'
        post :create, lounge: lounge.id, visit_date: '2016-12-03 17:30'
        expect(json_body[:errors][:visit_date]).to eq 'reserved'
      end
      it 'returns error' do
        Reservation.create! user: user, visit_date: '2016-12-03 19:00', table: table
        sign_in user2
        post :create, lounge: lounge.id, visit_date: '2016-12-03 18:00'#(DateTime.now + 6.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors][:visit_date]).to eq 'reserved'
      end
    end
    context 'когда есть два стола, один из которых - свободен' do
      let!(:lounge) { FactoryGirl.create :lounge }
      let!(:table) { FactoryGirl.create :table, lounge: lounge }
      let!(:table2) { FactoryGirl.create :table, lounge: lounge }
      it 'create reserv' do
        Reservation.create! user: user, visit_date: '2016-12-03 18:00', table: table
        sign_in user2
        post :create, lounge: lounge.id, visit_date: '2016-12-03 18:30'#(DateTime.now + 1.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors]).to_not be_present
      end
      it 'create reserv' do
        Reservation.create! user: user, visit_date: '2016-12-03 20:00', table: table
        sign_in user2
        post :create, lounge: lounge.id, visit_date: '2016-12-03 17:00'#(DateTime.now + 1.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors]).to_not be_present
      end
      it 'return error' do
        Reservation.create! user: user, visit_date: '2016-12-03 17:00', table: table
        Reservation.create! user: user, visit_date: '2016-12-03 18:00', table: table2
        sign_in user2
        post :create, lounge: lounge.id, visit_date: '2016-12-03 18:00'#(DateTime.now + 1.hours).strftime('%Y-%m-%d %R')
        expect(json_body[:errors]).to be_present
      end
      context 'когда один клиент бронирует на один и тот же день' do
        it 'returns error' do
          Reservation.create! user: user, visit_date: '2016-12-03 17:00', table: table
          post :create, lounge: lounge.id, visit_date: '2016-12-03 23:00'
          expect(json_body[:errors]).to be_present
        end
      end
    end
    context 'когда клиенты бронируют последовательно по времени' do
      context 'когда только один столик свободен' do
        it 'create reserv' do
          Reservation.create! user: user, visit_date: '2016-12-03 17:00', table: table
          sign_in user2
          post :create, lounge: lounge.id, visit_date: '2016-12-03 20:00'#(DateTime.now + 6.hours).strftime('%Y-%m-%d %R')
          expect(json_body[:errors]).to_not be_present
        end

        it 'create reserv' do
          Reservation.create! user: user, visit_date: '2016-12-03 20:00', table: table
          sign_in user2
          post :create, lounge: lounge.id, visit_date: '2016-12-03 17:00'#(DateTime.now + 1.hours).strftime('%Y-%m-%d %R')
          expect(json_body[:errors]).to_not be_present
        end
      end

      describe 'бронирование постоянников с обычными клиентами' do
        context 'когда есть один свободный стол' do
          let!(:table) { FactoryGirl.create :table, lounge: lounge }
          let!(:vip_user) { FactoryGirl.create :user, role: :vip }
          let!(:user) { FactoryGirl.create :user }

          context 'когда вип забронировал, его бронь длится 2 часа 30 минут' do
            before do
              Reservation.create user: vip_user, visit_date: '2016-12-03 17:00', table: table
              sign_in user
            end
            it 'errors' do
              post :create, lounge: lounge.id, visit_date: '2016-12-03 19:00'#(DateTime.now + 1.hours).strftime('%Y-%m-%d %R')
              expect(json_body[:errors][:visit_date]).to be_present
            end
            it 'ok' do
              post :create, lounge: lounge.id, visit_date: '2016-12-03 19:30'#(DateTime.now + 1.hours).strftime('%Y-%m-%d %R')
              expect(json_body[:errors]).to_not be_present
            end
          end
          context 'когда обычные клиент забронировал, его бронь длится 1 часа 30 минут' do
            before do
              Reservation.create user: user, visit_date: '2016-12-03 17:00', table: table
              sign_in vip_user
            end
            it 'ok' do
              post :create, lounge: lounge.id, visit_date: '2016-12-03 18:30'#(DateTime.now + 1.hours).strftime('%Y-%m-%d %R')
              expect(json_body[:errors]).to_not be_present
            end
            it 'error' do
              post :create, lounge: lounge.id, visit_date: '2016-12-03 18:00'#(DateTime.now + 1.hours).strftime('%Y-%m-%d %R')
              expect(json_body[:errors]).to be_present
            end
          end
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
            post :create, lounge: lounge.id, visit_date: '2016-12-03 20:00'
            expect(json_body[:errors]).to_not be_present
          end
        end
        context 'when user not vip' do
          before do
            sign_in user
          end
          it 'returns error' do
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
    describe 'meetup creation' do
      let!(:lounge) { FactoryGirl.create :lounge }
      let!(:table) { FactoryGirl.create :table, lounge: lounge }
      before do
        sign_in user
      end
      context 'если уровень таргета равен или ниже' do
        let(:user) { FactoryGirl.create :user, level: 0 }
        let(:target_user) { FactoryGirl.create :user, level: 0 }
        it "встреча создается" do
          expect {
            post :create, meets: [target_user.id], lounge: lounge.id, visit_date: (DateTime.now + 5.hours).strftime('%Y-%m-%d %R')
          }.to change { Meet.count }.from(0).to(1)
        end
      end
      context 'если уровень таргета выше' do
        let(:user) { FactoryGirl.create :user, level: 0 }
        let(:target_user) { FactoryGirl.create :user, level: 10 }
        it "ошибка" do
          expect {
            post :create, meets: [target_user.id], lounge: lounge.id, visit_date: (DateTime.now + 5.hours).strftime('%Y-%m-%d %R')
          }.to_not change { Meet.count }
        end
      end
    end
  end
  describe 'time pre validation' do
    context 'when user try to reserve to time is shorter than now + 1 hour' do
      let(:user) { FactoryGirl.create :user }
      let!(:lounge) { FactoryGirl.create :lounge }
      let!(:table) { FactoryGirl.create :table, lounge: lounge }
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in user
      end
      it 'returns error' do
        post :create, visit_date: (DateTime.now + 30.minutes).strftime('%Y-%m-%d %R'), lounge: lounge.id
        expect(json_body[:errors]).to be_present
      end
    end
  end
  describe '#destroy' do
    context 'когда пользователь отменяет свое бронирование' do
      let(:user) { FactoryGirl.create :user }
      let!(:lounge) { FactoryGirl.create :lounge }
      let!(:table) { FactoryGirl.create :table, lounge: lounge }
      before do
        sign_in user
        post :create, visit_date: (DateTime.now + 3.hours).strftime('%Y-%m-%d %R'), lounge: lounge.id
      end
      it 'меняет статус на отменено' do
        post :destroy, id: Reservation.first.id
        expect(response).to be_success
      end
    end
  end
end

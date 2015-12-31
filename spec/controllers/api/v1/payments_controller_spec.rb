require 'rails_helper'

RSpec.describe Api::V1::PaymentsController, type: :controller do
  before do
     allow_any_instance_of(User).to receive(:create_user_ext).and_return('1234')
  end
  describe '#create accepting external request about new payment' do
    let!(:user) { FactoryGirl.create :user, birthdate: Date.today - 20.years }
    let!(:lounge) { FactoryGirl.create :lounge }
    let!(:table) { FactoryGirl.create :table, lounge: lounge }
    it 'returns success responce' do
      post :create, phone: user.phone, format: :json
      expect(response).to be_success
    end
    it 'creates a new payment' do
      expect { post :create, phone: user.phone, amount: 1000, format: :json }
        .to change { Payment.count }
    end
    describe "связь с бронированием" do
      let!(:reservation) { FactoryGirl.create :reservation, user: user, idrref: 'fakeref', code: 'fakecode', visit_date: DateTime.now + 5.days, table: table }
      it "создает запись платежа с бронированием" do
        post :create, phone: user.phone, amount: 1000, reservation_code: 'fakecode', format: :json
        expect(Payment.first.reservation_id).to eq reservation.id
      end

    end
    describe 'experience logick' do
      it 'add exp point to user 1 ruble == 0.01 exp point' do
        expect { post :create, phone: user.phone, amount: 1000, format: :json }
          .to change { User.find(user.id).experience }.from(0).to(1000)
      end

      describe 'when exp is enought to level-up' do
        it 'upgrade user level' do
          expect { post :create, phone: user.phone, amount: 6900, format: :json }
            .to change { User.find(user.id).level }.from(1).to(2)
        end
        it 'add one skill point to user' do
          expect { post :create, phone: user.phone, amount: 6900, format: :json }
            .to change { User.find(user.id).skill_point }.from(0).to(1)
        end
      end
    end
  end
end

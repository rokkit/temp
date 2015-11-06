require 'rails_helper'

RSpec.describe Api::V1::PaymentsController, type: :controller do
  describe '#create accepting external request about new payment' do
    let!(:user) { FactoryGirl.create :user }
    it 'returns success responce' do
      post :create, phone: user.phone, amount: 1000, format: :json
      expect(response).to be_success
    end
    it 'creates a new payment' do
      expect { post :create, phone: user.phone, amount: 1000, format: :json }
        .to change { Payment.count }
    end
    describe 'experience logick' do
      it 'add exp point to user 1 ruble == 0.01 exp point' do
        expect { post :create, phone: user.phone, amount: 1000, format: :json }
          .to change { User.find(user.id).experience }.from(0).to(10)
      end

      describe 'when exp is enought to level-up' do
        it 'upgrade user level' do
          expect { post :create, phone: user.phone, amount: 100_000, format: :json }
            .to change { User.find(user.id).level }.from(1).to(2)
        end
        it 'add one skill point to user' do
          expect { post :create, phone: user.phone, amount: 100_000, format: :json }
            .to change { User.find(user.id).skill_point }.from(0).to(1)
        end
      end
    end
  end
end

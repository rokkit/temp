require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe "Добавление опыта клиенту после создания" do
    let(:user) { FactoryGirl.create :user }
    context 'когда платеж 1000р.' do
      before do
        Payment.create user_id: user.id, amount: 1000
        user.reload
      end
      it 'начисляет клиенту 1000 опыта' do
        expect(user.total_experience).to eq 1000
      end
      it 'оставляет 1 уровень' do
        expect(user.level).to eq 1
      end
    end
    context 'когда платеж 6001р.' do
      before do
        Payment.create user_id: user.id, amount: 6001
        user.reload
      end
      it 'начисляет клиенту 6001 опыта' do
        expect(user.total_experience).to eq 6001
      end
      it '2 уровень' do
        expect(user.level).to eq 2
      end

    end
  end
end

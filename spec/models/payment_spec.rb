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
  describe "распределение опыта между участниками встречи" do
    let(:user) { FactoryGirl.create :user }
    let(:user_in_meet) { FactoryGirl.create :user }
    let!(:reservation) {
      FactoryGirl.create :reservation,
                         visit_date: DateTime.now + 5.days,
                         user: user,
                         meets: []
    }
    it 'начисляет поровну опыт всем участникам встречи' do
      Meet.create(user: user_in_meet, reservation: reservation, status: 1)
      Payment.create user: user, reservation: reservation, amount: 4000
      user.reload
      user_in_meet.reload
      expect(user.total_experience + user_in_meet.total_experience).to eq 4000
      expect(user.total_experience).to eq 2000
      expect(user_in_meet.total_experience).to eq 2000
    end
    it 'начисляет поровну опыт всем участникам встречи со всех их платежей' do
      Meet.create(user: user_in_meet, reservation: reservation, status: 1)
      Payment.create user: user, reservation: reservation, amount: 4000
      Payment.create user: user_in_meet, reservation: reservation, amount: 2000
      user.reload
      user_in_meet.reload
      expect(user.total_experience + user_in_meet.total_experience).to eq 6000
      expect(user.total_experience).to eq 3000
      expect(user_in_meet.total_experience).to eq 3000
    end
    context 'если один участник не подтвердил встречу' do
      let(:user_not_meet) { FactoryGirl.create :user }
      it 'начисляет опыт подтвердившим участие' do
        Meet.create(user: user_in_meet, reservation: reservation, status: 1)
        Meet.create(user: user_not_meet, reservation: reservation, status: 0)
        Payment.create user: user, reservation: reservation, amount: 4000
        user.reload
        user_in_meet.reload
        user_not_meet.reload
        expect(user.total_experience + user_in_meet.total_experience).to eq 4000
        expect(user.total_experience).to eq 2000
        expect(user_in_meet.total_experience).to eq 2000
        expect(user_not_meet.total_experience).to eq 0
      end
    end
  end

end

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  render_views
  before do
     allow_any_instance_of(User).to receive(:create_user_ext).and_return('1234')
  end

  describe '#update' do
    let!(:user) { FactoryGirl.create :user, name: 'Name' }
    before do
      sign_in user

    end
    it "updates user profile" do
      put :update, id: user.id, user: {name: 'New Name' }, format: :json
      user.reload
      expect(json_body[:name]).to eq user.name
    end
    context 'когда клиент обновляет дату рождения' do
      it "обновляется запись в 1с" do
        put :update, id: user.id, user: {birthdate: (Date.today - 20.years)}, format: :json
        user.reload
        expect(json_body[:birthdate]).to be_present
      end
    end
    describe '"Open Profile" achievement' do
      context 'when all profile attributes filled' do
        it 'add achievement to user' do
          put :update, id: user.id,
            name: 'New Name',
            hobby: 'Hobby',
            employe: 'employe',
            work_company: 'work',
            city: 'City17',
            format: :json
          user.reload
          expect(user.achievements.first).to eq Achievement.first
          expect(json_body[:achievements]).to eq [{id: Achievement.first.id, name: Achievement.first.name}]
        end
      end
    end
    describe 'Достижение "Изобретательность"' do
      context 'когда провел 1 мероприятие' do
        it 'добавляет достижение для юзера' do
          user.update_attribute :party_count, 1
          user.reload
          achievement = Achievement.find_by_key('izobretatelnost-i')
          expect(user.achievements.first).to eq achievement
        end
      end
    end
  end

  describe '#rating' do
    context 'рейтинг клиентов' do
      let!(:user) { FactoryGirl.create :user }
      let!(:user2) { FactoryGirl.create :user }
      before do
        sign_in user
      end
      it "возвращает рейтинг пользователей пустой" do
        get :rating, role: 'user', format: :json
        expect(json_body[:users_month]).to eq []
        expect(json_body[:users_all_time]).to eq []
      end
      describe "рейтинг за все время" do
        let!(:user3) { FactoryGirl.create :user, experience: 3000 }
        let!(:user4) { FactoryGirl.create :user, experience: 8000 }
        it "возвращает рейтинг пользователей" do
          get :rating, role: 'user', format: :json
          expect(json_body[:users_month]).to eq []
          expect(json_body[:users_all_time]).to eq [
            {id: user4.id, name: user4.name, exp: user4.total_experience},
            {id: user3.id, name: user3.name, exp: user3.total_experience}
          ]
        end
      end
      describe "рейтинг за месяц" do
        let!(:user3) { FactoryGirl.create :user }
        let!(:payment) { FactoryGirl.create :payment, user: user3, amount: 3000, payed_at: DateTime.now - 3.days }
        let!(:payment2) { FactoryGirl.create :payment, user: user3, amount: 1000, payed_at: DateTime.now - 2.days }
        let!(:payment_user_old) { FactoryGirl.create :payment, user: user3, amount: 3000, payed_at: DateTime.now - 2.months }
        let!(:payment_old) { FactoryGirl.create :payment, user: user, amount: 2000, payed_at: DateTime.now - 2.months }
        it "возвращает рейтинг пользователей" do
          get :rating, role: 'user', format: :json
          expect(json_body[:users_month]).to eq [{id: user3.id, name: user3.name, exp: 4000}]
          expect(json_body[:users_all_time]).to eq [
            {id: user3.id, name: user3.name, exp: user3.total_experience},
            {id: user.id, name: user.name, exp: user.total_experience}
          ]
        end
      end
    end
    context 'рейтинг кальянщика' do
      let!(:user) { FactoryGirl.create :user, role: 'hookmaster' }
      let!(:user2) { FactoryGirl.create :user, role: 'hookmaster' }
      let!(:client) { FactoryGirl.create :user, role: 'user' }
      let!(:lounge) { FactoryGirl.create :lounge }
      let!(:table) { FactoryGirl.create :table, lounge: lounge }
      before do
        sign_in user
      end
      it "возвращает рейтинг пользователей пустой" do
        get :rating, role: 'hookmaster', format: :json
        expect(json_body[:users_month]).to eq []
        expect(json_body[:users_all_time]).to eq []
      end
      describe "рейтинг за все время" do
        let!(:payment) { FactoryGirl.create :payment, table: table, amount: 1000, payed_at:  DateTime.now - 2.months, user: client}
        let!(:payment2) { FactoryGirl.create :payment, table: table, amount: 2000, payed_at:  DateTime.now - 2.months, user: client}
        let!(:user3) { FactoryGirl.create :user, role: 'hookmaster' }
        let!(:user4) { FactoryGirl.create :user, role: 'hookmaster' }
        let!(:work) { FactoryGirl.create :work, user: user3, amount: 1000, work_at: DateTime.now - 2.months, lounge: lounge }
        let!(:work2) { FactoryGirl.create :work, user: user4, amount: 2000, work_at: DateTime.now - 2.months, lounge: lounge }
        it "возвращает рейтинг пользователей" do
          get :rating, role: 'hookmaster', format: :json
          expect(json_body[:users_month]).to eq []
          expect(json_body[:users_all_time]).to eq [
            {id: user4.id, name: user4.name, exp: 1500},
            {id: user3.id, name: user3.name, exp: user3.total_experience}
          ]
        end
      end
      describe "рейтинг за месяц" do
        let!(:user3) { FactoryGirl.create :user, role: 'hookmaster' }
        let!(:payment) { FactoryGirl.create :payment, table: table, amount: 1000, payed_at:  DateTime.now, user: client}
        let!(:payment2) { FactoryGirl.create :payment, table: table, amount: 5000, payed_at:  DateTime.now- 2.months, user: client}
        let!(:payment3) { FactoryGirl.create :payment, table: table, amount: 3000, payed_at:  DateTime.now- 2.months, user: client}
        let!(:work) { FactoryGirl.create :work, user: user3, amount: 1000, work_at: DateTime.now, lounge: lounge }
        let!(:work2) { FactoryGirl.create :work, user: user3, amount: 5000, work_at: DateTime.now - 2.months, lounge: lounge }
        let!(:work3) { FactoryGirl.create :work, user: user, amount: 3000, work_at: DateTime.now - 2.months, lounge: lounge }
        it "возвращает рейтинг пользователей" do
          get :rating, role: 'hookmaster', format: :json
          expect(json_body[:users_month]).to eq [{id: user3.id, name: user3.name, exp: 1000}]
          expect(json_body[:users_all_time]).to eq [
            {id: user3.id, name: user3.name, exp: 5000},
            {id: user.id, name: user.name, exp: 4000}
          ]
        end
      end
    end

  end
end

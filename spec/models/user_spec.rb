require 'rails_helper'

RSpec.describe 'User' do
   describe "Опыт кальянного мастера" do
     let(:user) { FactoryGirl.create :user, role: :hookmaster }
     let(:client) { FactoryGirl.create :user, role: :user }
     let(:lounge) { FactoryGirl.create :lounge }
     let(:table) { FactoryGirl.create :table, lounge: lounge }
     describe 'опыт равен сумме платежей заведения за сутки / кол-во смен' do
       context 'когда платежей нет' do
         it 'опыт == 0' do
           expect(user.total_experience).to eq(0)
         end
       end
       context 'когда есть платеж и рабочая смена за сутки' do
         let!(:payment) { FactoryGirl.create :payment, amount: 1000, user: client, table: table }
         let!(:work) { FactoryGirl.create :work, user: user, lounge: lounge }
         it 'вычисляется опыт' do
           expect(user.total_experience).to eq(1000)
         end
       end
       context 'когда есть платеж и рабочая смена за несколько месяцев' do
         let!(:payment) { FactoryGirl.create :payment, amount: 1000, user: client, table: table }
         let!(:payment2) { FactoryGirl.create :payment, amount: 2000, user: client, table: table }
         let!(:work) { FactoryGirl.create :work, user: user, lounge: lounge}
         let!(:payment3) { FactoryGirl.create :payment, amount: 1000, user: client, table: table }
         let!(:work2) { FactoryGirl.create :work, user: user, lounge: lounge, work_at: DateTime.now - 1.month}
         before do
           payment3.update_attribute :created_at, DateTime.now - 1.month
         end
         it 'вычисляется опыт' do
           expect(user.total_experience).to eq(4000)
           expect(user.need_to_levelup).to eq(1225)
         end
       end
       context 'когда есть платеж и рабочая смена за несколько месяцев и два кальящика' do
         let!(:payment) { FactoryGirl.create :payment, amount: 1000, user: client, table: table }
         let!(:payment2) { FactoryGirl.create :payment, amount: 2000, user: client, table: table }
         let!(:work) { FactoryGirl.create :work, user: user, lounge: lounge}
         let!(:payment3) { FactoryGirl.create :payment, amount: 1000, user: client, table: table }
         let!(:work2) { FactoryGirl.create :work, user: user, lounge: lounge, work_at: DateTime.now - 1.month}
         let(:user2) { FactoryGirl.create :user, role: :hookmaster }
         before do
           payment3.update_attribute :created_at, DateTime.now - 1.month
         end
         it 'вычисляется опыт' do
           expect(user.total_experience).to eq(4000)
           expect(user.need_to_levelup).to eq(1225)
         end
         it 'у второго кальянщика не должно быть опыта' do
           expect(user2.total_experience).to eq(0)
           expect(user2.need_to_levelup).to eq(5225)
         end
       end
     end
   end
   describe "Уровень кальянного мастера" do
     let(:user) { FactoryGirl.create :user, role: :hookmaster }
     let(:client) { FactoryGirl.create :user, role: :user }
     let(:lounge) { FactoryGirl.create :lounge }
     let(:table) { FactoryGirl.create :table, lounge: lounge }
     context 'когда опыта 1000' do
       let!(:payment) { FactoryGirl.create :payment, amount: 1000, user: client, table: table }
       let!(:work) { FactoryGirl.create :work, user: user, lounge: lounge }
       it 'уровень == 1' do
         expect(user.current_level).to eq(1)
       end
     end
     context 'когда опыта 5226' do
       let!(:payment) { FactoryGirl.create :payment, amount: 5226, user: client, table: table }
       let!(:work) { FactoryGirl.create :work, user: user, lounge: lounge }
       it 'уровень == 1' do
         expect(user.current_level).to eq(2)
       end
     end
     context 'когда опыта 52260' do
       let!(:payment) { FactoryGirl.create :payment, amount: 52260, user: client, table: table }
       let!(:work) { FactoryGirl.create :work, user: user, lounge: lounge }
       it 'уровень == 10' do
         expect(user.current_level).to eq(10)
       end
     end
     context 'когда опыта 208991' do
       let!(:payment) { FactoryGirl.create :payment, amount: 208991, user: client, table: table }
       let!(:work) { FactoryGirl.create :work, user: user, lounge: lounge }
       it 'уровень == 21' do
         expect(user.current_level).to eq(20)
       end
     end
     context 'когда опыта много' do
       let!(:payment) { FactoryGirl.create :payment, amount: 100000000, user: client, table: table }
       let!(:work) { FactoryGirl.create :work, user: user, lounge: lounge }
       it 'уровень максимальный' do
         expect(user.current_level).to eq(30)
       end
     end
   end

   describe "Уровень клиента" do
     let(:user) { FactoryGirl.create :user, role: :hookmaster }

     let(:lounge) { FactoryGirl.create :lounge }
     let(:table) { FactoryGirl.create :table, lounge: lounge }
     context 'когда клиент 1 уровня' do
       let(:client) { FactoryGirl.create :user, role: :user }
       context 'когда один платеж на 2000р.' do
         let!(:payment) { FactoryGirl.create :payment, amount: 2000, user: client, table: table }
         it "уровень равен 1" do
           expect(client.level).to eq 1
         end
         it 'до следующего уровня 4000 опыта' do
           expect(client.need_to_levelup).to eq 4000
         end
       end
       context 'когда один платеж на 6000р.' do
         let!(:payment) { FactoryGirl.create :payment, amount: 6000, user: client, table: table }
         it "уровень равен 2" do
           client.reload
           expect(client.level).to eq 2
         end
         it 'до следующего уровня 19200 опыта' do
           expect(client.need_to_levelup).to eq 19200
         end
       end
       context 'когда один платеж на 6500р.' do
         let!(:payment) { FactoryGirl.create :payment, amount: 6500, user: client, table: table }
         it "уровень равен 2" do
           client.reload
           expect(client.level).to eq 2
         end
         it "уровень равен 2" do
           client.reload
           expect(client.skill_point).to eq 1
         end
         it 'до следующего уровня 18700 опыта' do
           expect(client.need_to_levelup).to eq 18700
         end
       end
     end
     context 'когда клиент 2 уровня' do
       let(:client) { FactoryGirl.create :user, role: :user, level: 2, experience: 6000 }
       context 'когда один платеж на 1000р.' do
         let!(:payment) { FactoryGirl.create :payment, amount: 1000, user: client, table: table }
         it "уровень равен 2" do
           client.reload
           expect(client.level).to eq 2
         end
         it 'до следующего уровня 13172 опыта' do
           expect(client.need_to_levelup).to eq 18200
         end
       end
     end
   end
end

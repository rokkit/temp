require 'rails_helper'

RSpec.describe Api::V1::MeetsController, type: :controller do
  render_views
  before do
    #  expect_any_instance_of(User).to receive(:create_user_ext).and_return('1234')
     allow_any_instance_of(User).to receive(:create_user_ext).and_return('1234')
  end
  describe "POST #accept" do
    let(:user) { FactoryGirl.create :user }
    let(:target_user) { FactoryGirl.create :user }
    let!(:lounge) { FactoryGirl.create :lounge }
    let!(:table) { FactoryGirl.create :table, lounge: lounge }
    let(:reservation) { FactoryGirl.create :reservation, visit_date: DateTime.now + 5.days, table: table, user: user }
    let(:meet) { FactoryGirl.create :meet, user: target_user, reservation: reservation }
    before do
      sign_in user
    end
    it "меняет статус пригляшения на 'принято'" do
      expect {
         post :accept, id: meet.id, format: :json
         meet.reload
       }.to change {
        meet.status
      }.from('wait').to('approved')
    end
  end
  describe "POST #decline" do
    let(:user) { FactoryGirl.create :user }
    let(:target_user) { FactoryGirl.create :user }
    let!(:lounge) { FactoryGirl.create :lounge }
    let!(:table) { FactoryGirl.create :table, lounge: lounge }
    let(:reservation) { FactoryGirl.create :reservation, visit_date: DateTime.now + 5.days, table: table, user: user }
    let(:meet) { FactoryGirl.create :meet, user: target_user, reservation: reservation }
    before do
      sign_in user
    end
    it "меняет статус пригляшения на 'отменено'" do
      expect {
         post :decline, id: meet.id, format: :json
         meet.reload
       }.to change {
        meet.status
      }.from('wait').to('deleted')
    end
    it "меняет статус бронирования на 'отменено'" do
      expect {
         post :decline, id: meet.id, format: :json
         reservation.reload
       }.to change {
        reservation.status
      }.from('wait').to('deleted')
    end
  end
end

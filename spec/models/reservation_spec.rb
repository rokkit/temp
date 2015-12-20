require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe "1С integration" do
    let(:user) { FactoryGirl.create :user }
    let!(:lounge) { FactoryGirl.create :lounge }
    let!(:table) { FactoryGirl.create :table, lounge: lounge }
    it 'создает запись в 1С' do
      Reservation.create! user: user, visit_date: '2016-12-03 18:00', table: table
      
    end
  end
end

# require 'rails_helper'
#
# RSpec.describe Reservation, type: :model do
#   before do
#      allow_any_instance_of(User).to receive(:create_user_ext).and_return('1234')
#   end
#   describe "создание брони" do
#     context 'когда несколько участников' do
#       let!(:user) { FactoryGirl.create :user }
#       let!(:user2) { FactoryGirl.create :user }
#       it "создает бронирование со встречей" do
#         Reservation.create :user, meets: [user.id]
#       end
#     end
#   end
# end

require 'rails_helper'

RSpec.describe Api::V1::PaymentsController, type: :controller do
  describe "accepting external request about new payment" do
    let!(:user) { FactoryGirl.create :user }
    it 'should return success responce' do
      post :create, phone: user.phone, amount: 1000,format: :json
      expect(response).to be_success
    end
    it 'should creates a new payment' do
      expect { post :create, phone: user.phone, amount: 1000, format: :json }
      .to change { Payment.count }
    end
    describe "experience logick" do
      it "should add exp point to user 1 ruble == 0.01 exp point" do
        expect { post :create, phone: user.phone, amount: 1000, format: :json }
        .to change { User.find(user.id).experience }.from(0).to(10)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Api::V1::PaymentsController, type: :controller do
  describe "accepting external request about new payment" do
    it 'should creates a new payment'# do
      # expect { post :create, format: :json }.to change { Payment.count }
    # end

    it 'should return success responce' do
      post :create, format: :json
      expect(response).to be_success
    end
  end
end

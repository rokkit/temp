require 'rails_helper'

RSpec.describe Api::V1::WorksController, type: :controller do
  render_views
  before do
     allow_any_instance_of(User).to receive(:create_user_ext).and_return('1234')
  end
  let!(:user) { FactoryGirl.create :user, role: :hookmaster }
  let!(:lounge) { FactoryGirl.create :lounge }
  before do
    sign_in user
  end
  describe '#index' do
    let!(:work) { FactoryGirl.create :work, user: user, amount: 5000, lounge: lounge }
    it 'returns list of works' do
      get :index, format: :json
      expect_json_types(:array)
      expect(json_body[0][:id]).to eq work.id
      expect(json_body[0][:amount]).to eq work.amount.to_s
    end
  end
end

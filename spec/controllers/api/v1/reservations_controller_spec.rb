require 'rails_helper'

RSpec.describe Api::V1::ReservationsController, type: :controller do
  render_views
  describe "when user make a reservation request" do
    let(:user) { FactoryGirl.create :user }
    let!(:lounge) { FactoryGirl.create :lounge }
    let!(:table) { FactoryGirl.create :table, lounge: lounge }
    describe "with valid params" do


      it "should create a record to user" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
        post :create, {table_id: table.id, visit_date: DateTime.now + 5.hours}
        expect(response).to be_success
      end
    end
    describe "when past visit date present" do
      it "should reject request" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
        post :create, {table_id: table.id, visit_date: DateTime.now - 5.hours}
        expect(json_body[:errors]).to be_present
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "FranchiseRequests", type: :request do
  describe "GET /franchise_requests" do
    it "works! (now write some real specs)" do
      get franchise_requests_path
      expect(response).to have_http_status(200)
    end
  end
end

require "rails_helper"

RSpec.describe FranchiseRequestsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/franchise_requests").to route_to("franchise_requests#index")
    end

    it "routes to #new" do
      expect(:get => "/franchise_requests/new").to route_to("franchise_requests#new")
    end

    it "routes to #show" do
      expect(:get => "/franchise_requests/1").to route_to("franchise_requests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/franchise_requests/1/edit").to route_to("franchise_requests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/franchise_requests").to route_to("franchise_requests#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/franchise_requests/1").to route_to("franchise_requests#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/franchise_requests/1").to route_to("franchise_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/franchise_requests/1").to route_to("franchise_requests#destroy", :id => "1")
    end

  end
end

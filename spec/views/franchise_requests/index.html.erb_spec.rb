require 'rails_helper'

RSpec.describe "franchise_requests/index", type: :view do
  before(:each) do
    assign(:franchise_requests, [
      FranchiseRequest.create!(
        :fio => "Fio",
        :contact_phone => "Contact Phone",
        :email => "Email",
        :city => "City",
        :about => "About",
        :employe_phone => "Employe Phone",
        :employe_status => "Employe Status",
        :first_payment => "First Payment",
        :total_payment => "Total Payment"
      ),
      FranchiseRequest.create!(
        :fio => "Fio",
        :contact_phone => "Contact Phone",
        :email => "Email",
        :city => "City",
        :about => "About",
        :employe_phone => "Employe Phone",
        :employe_status => "Employe Status",
        :first_payment => "First Payment",
        :total_payment => "Total Payment"
      )
    ])
  end

  it "renders a list of franchise_requests" do
    render
    assert_select "tr>td", :text => "Fio".to_s, :count => 2
    assert_select "tr>td", :text => "Contact Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "About".to_s, :count => 2
    assert_select "tr>td", :text => "Employe Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Employe Status".to_s, :count => 2
    assert_select "tr>td", :text => "First Payment".to_s, :count => 2
    assert_select "tr>td", :text => "Total Payment".to_s, :count => 2
  end
end

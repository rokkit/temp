require 'rails_helper'

RSpec.describe "franchise_requests/show", type: :view do
  before(:each) do
    @franchise_request = assign(:franchise_request, FranchiseRequest.create!(
      :fio => "Fio",
      :contact_phone => "Contact Phone",
      :email => "Email",
      :city => "City",
      :about => "About",
      :employe_phone => "Employe Phone",
      :employe_status => "Employe Status",
      :first_payment => "First Payment",
      :total_payment => "Total Payment"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Fio/)
    expect(rendered).to match(/Contact Phone/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/About/)
    expect(rendered).to match(/Employe Phone/)
    expect(rendered).to match(/Employe Status/)
    expect(rendered).to match(/First Payment/)
    expect(rendered).to match(/Total Payment/)
  end
end

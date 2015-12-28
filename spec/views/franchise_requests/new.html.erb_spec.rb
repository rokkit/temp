require 'rails_helper'

RSpec.describe "franchise_requests/new", type: :view do
  before(:each) do
    assign(:franchise_request, FranchiseRequest.new(
      :fio => "MyString",
      :contact_phone => "MyString",
      :email => "MyString",
      :city => "MyString",
      :about => "MyString",
      :employe_phone => "MyString",
      :employe_status => "MyString",
      :first_payment => "MyString",
      :total_payment => "MyString"
    ))
  end

  it "renders new franchise_request form" do
    render

    assert_select "form[action=?][method=?]", franchise_requests_path, "post" do

      assert_select "input#franchise_request_fio[name=?]", "franchise_request[fio]"

      assert_select "input#franchise_request_contact_phone[name=?]", "franchise_request[contact_phone]"

      assert_select "input#franchise_request_email[name=?]", "franchise_request[email]"

      assert_select "input#franchise_request_city[name=?]", "franchise_request[city]"

      assert_select "input#franchise_request_about[name=?]", "franchise_request[about]"

      assert_select "input#franchise_request_employe_phone[name=?]", "franchise_request[employe_phone]"

      assert_select "input#franchise_request_employe_status[name=?]", "franchise_request[employe_status]"

      assert_select "input#franchise_request_first_payment[name=?]", "franchise_request[first_payment]"

      assert_select "input#franchise_request_total_payment[name=?]", "franchise_request[total_payment]"
    end
  end
end

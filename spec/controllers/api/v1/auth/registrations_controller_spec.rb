require 'rails_helper'

RSpec.describe Api::V1::Auth::RegistrationsController, type: :controller do
  describe "registration with valid params" do
    it 'test' do
      get api_v1_registrations_path
    end
  end

end

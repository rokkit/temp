class FranchiseRequestsController < InheritedResources::Base
  skip_before_action :verify_authenticity_token
  respond_to :json
  private

    def franchise_request_params
      params.require(:franchise_request).permit(:fio, :contact_phone, :email, :city, :about, :employe_phone, :employe_status, :first_payment, :total_payment)
    end
end

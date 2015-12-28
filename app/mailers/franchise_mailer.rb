class FranchiseMailer < ApplicationMailer
  def new_request(franchise_request)
    @franchise_request = franchise_request
    mail(to: 'info@uhpfamily.com', subject: 'Заявка франшизы УК')
  end
end

json.array!(@franchise_requests) do |franchise_request|
  json.extract! franchise_request, :id, :fio, :contact_phone, :email, :city, :about, :employe_phone, :employe_status, :first_payment, :total_payment
  json.url franchise_request_url(franchise_request, format: :json)
end

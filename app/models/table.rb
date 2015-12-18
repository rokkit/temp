class Table < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  # establish_connection :uk_external_development
  # self.table_name = '_reference27'
  belongs_to :lounge
  validates :lounge, presence: true


  def self.tables_from_1c(lounge_id)
    begin
    lounge = Lounge.find(lounge_id)
    if lounge.code
      response = SoapService.call(:table_list_by_place, message: { 'Place' => lounge.code })
      return response[:table_list_by_place_response][:return][:'Столы']
    else
      []
    end
    rescue ActiveRecord::RecordNotFound
      []
    end
  end
end

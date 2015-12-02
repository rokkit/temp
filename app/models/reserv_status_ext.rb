class ReservStatusExt < ActiveRecord::Base
  establish_connection :uk_external_development
  self.table_name = '_enum113'
end

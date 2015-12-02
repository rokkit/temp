class TableReservExt < ActiveRecord::Base
  establish_connection :uk_external_development
  self.table_name = '_document74'
end

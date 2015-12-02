class TableExt < ActiveRecord::Base
  establish_connection :uk_external_development
  self.table_name = '_reference27'
end

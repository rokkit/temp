class LoungeExt < ActiveRecord::Base
  establish_connection :uk_external_development
  self.table_name = '_reference29'
end

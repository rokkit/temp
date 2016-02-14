class WorkTypeExt < ActiveRecord::Base
  establish_connection({
    :adapter     => "sqlserver",
    :host          => "176.112.198.251",
    :username => "Sa",
    :password => "kpa64Mys",
    :database => "uhp_demo1"
  })
  self.table_name = '_Enum1665'
  self.primary_key = '_IDRRef'
end

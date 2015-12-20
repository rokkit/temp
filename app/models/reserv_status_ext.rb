class ReservStatusExt < ActiveRecord::Base
  establish_connection({
    :adapter     => "sqlserver",
    :host          => "176.112.198.251",
    :username => "sa",
    :password => "Ve8Rohcier",
    :database => "uhp_demo1"
  })
  self.table_name = '_enum113'
end

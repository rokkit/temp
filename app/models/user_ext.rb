class UserExt < ActiveRecord::Base
  # establish_connection :uk_external_development

  establish_connection({
    :adapter     => "sqlserver",
    :host          => "176.112.198.251",
    :username => "sa",
    :password => "Ve8Rohcier",
    :database => "uhp_demo1"
  })
  self.table_name = '_reference42'

  def phone
    self._fld496
  end

  def phone=(p)
    self._fld496 = p
  end
end

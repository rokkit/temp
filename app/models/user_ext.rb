class UserExt < ActiveRecord::Base
  establish_connection :uk_external_development
  self.table_name = '_reference42'

  def phone
    self._fld496
  end

  def phone=(p)
    self._fld496 = p
  end
end

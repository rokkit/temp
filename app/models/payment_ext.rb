class PaymentExt < ActiveRecord::Base
  establish_connection({
    :adapter     => "sqlserver",
    :host          => "176.112.198.251",
    :username => "sa",
    :password => "Ve8Rohcier",
    :database => "uhp_demo1"
  })
  self.table_name = '_accumrg1568'
  self.primary_key = '_period'

  def user
    self._fld1663rref
  end
  def amount
    self._fld1575
  end
end

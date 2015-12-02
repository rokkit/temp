class PaymentExt < ActiveRecord::Base
  establish_connection :uk_external_development
  self.table_name = '_accumrg1568'

  def user
    self._fld1663rref
  end
  def amount
    self._fld1575
  end
end

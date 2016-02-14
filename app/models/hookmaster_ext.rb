class HookmasterExt < ActiveRecord::Base

  establish_connection({
    :adapter     => "sqlserver",
    :host          => "176.112.198.251",
    :username => "Sa",
    :password => "kpa64Mys",
    :database => "uhp_demo1"
  })
  self.table_name = '_Reference26'
  self.primary_key = '_IDRRef'


  # Получить смены из 1С
  def works_ext
    WorkExt.where(_Fld1667RRef: self._IDRRef)
  end



end

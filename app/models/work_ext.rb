class WorkExt < ActiveRecord::Base
  establish_connection({
    :adapter     => "sqlserver",
    :host          => "176.112.198.251",
    :username => "sa",
    :password => "kpa64Mys",
    :database => "uhp_demo1"
  })
  self.table_name = '_InfoRg1666'
  self.primary_key = '_Period'

  # Получить тип записи (Вход, Выход, Документ)
  def action_type
    action_names = ['Вход', 'Выход', 'Документ']
    action = WorkTypeExt.where(_IDRRef: self._Fld1668RRef).first
    if action
      action_names[action._EnumOrder.to_i]
    end
  end
end

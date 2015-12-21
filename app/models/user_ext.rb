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
  self.primary_key = '_IDRRef'

  def phone
    self._fld496
  end

  def phone=(p)
    self._fld496 = p
  end

  def get_idrref
    binary_to_string(self._IDRRef)
  end

  def string_to_binary(value)
    "0x#{value}"
  end


  def binary_to_string(value)
    if value.length == 16
      value = value.unpack('C*').map{ |b| "%02X" % b }.join('')
    else
      value =~ /[^[:xdigit:]]/ ? value : [value].pack('H*')
    end
  end
end

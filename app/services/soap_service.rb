class SoapService
  def self.call(method, params)
    if !Rails.env.test?
      begin
      client = Savon.client(wsdl: 'http://176.112.198.251/uhp_demo1/ws/obmen.1cws?wsdl')
      response = client.call(method, params)
      puts response.body.inspect
      return response.body
      rescue Savon::HTTPError
      end
    end
    true
  end

  def self.call_raw(method, params)
      begin
      client = Savon.client(wsdl: 'http://176.112.198.251/uhp_demo1/ws/obmen.1cws?wsdl')
      response = client.call(method, params)
      puts response.body.inspect
      return response.body
      rescue Savon::HTTPError
      end
  end
end

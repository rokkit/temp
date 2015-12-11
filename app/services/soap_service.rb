class SoapService
  def self.call(method, params)
    begin
    client = Savon.client(wsdl: 'http://176.112.198.251/uhp_demo1/ws/obmen.1cws?wsdl')
    response = client.call(method, params)
    puts response.body.inspect
    rescue Savon::HTTPError
    end
    true
  end
end

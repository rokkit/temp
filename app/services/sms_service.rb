class SMSService
  # Отправить смс на указанный номер, используя сторонний СМС сервис
  # TODO: Пока заглушка
  def self.send(phone, text)
    # if !Rails.env.test?
    #   request = Net::HTTP.post_form URI.parse('http://smsc.ru/sys/send.php'),
    #    {
    #      'login' => 'uhp',
    #      'psw' => 'uhppassword',
    #      'phones' => "#{phone}",
    #      'mes' => text,
    #      'charset' => 'utf-8'
    #    }
    #    puts request.body.inspect
    #  end
  end
end

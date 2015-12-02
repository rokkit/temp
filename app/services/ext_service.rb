class ExtService
  def self.execute(query)
    ActiveRecord::Base.establish_connection(:uk_external_development).connection.execute(query)
  end
end

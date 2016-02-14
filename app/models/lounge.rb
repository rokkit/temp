class Lounge < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :city
  mount_uploader :blazon, BlazonUploader

  has_many :tables
  has_many :hookmasters, -> { hookmasters }, class_name: 'User'
  has_many :photos, class_name: 'LoungePhoto'

  accepts_nested_attributes_for :photos, :allow_destroy => true

  def get_from_ext_by_title
     client = TinyTds::Client.new username: 'Sa',
            password: 'kpa64Mys',
            host: '176.112.198.251',
            port: 1433,
            database: 'uhp_demo1',
            azure:false


      query = """
      SELECT  [_Reference29].* FROM [_Reference29]
      WHERE [_Reference29].[_Description] = '#{self.title}'
      """
      results = client.execute query
      rows = []
      results.each do |row|
        rows.push row
      end
      return rows.try(:first)
  end

  def self.get_from_ext(idrref)
    client = TinyTds::Client.new username: 'Sa',
            password: 'kpa64Mys',
            host: '176.112.198.251',
            port: 1433,
            database: 'uhp_demo1',
            azure:false
    idrref_binary = self.binary_to_string(idrref)
    query = """
    EXEC sp_executesql N'SELECT  [_Reference29].* FROM [_Reference29]
    WHERE [_Reference29].[_IDRRef] = 0x#{idrref_binary}'
    """
    results = client.execute query
    rows = []
    results.each do |row|
      rows.push row
    end
    if rows.length != 0
      return rows[0]
    end
  end



  def self.binary_to_string(value)
    if value.length == 16
      value = value.unpack('C*').map{ |b| "%02X" % b }.join('')
    else
      value =~ /[^[:xdigit:]]/ ? value : [value].pack('H*')
    end
  end

  def self.string_to_binary(value)
    "0x#{value}"
  end
end

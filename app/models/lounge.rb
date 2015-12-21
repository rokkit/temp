class Lounge < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :city
  mount_uploader :blazon, BlazonUploader

  has_many :tables
  has_many :hookmasters, class_name: 'User'
  has_many :photos, class_name: 'LoungePhoto'

  accepts_nested_attributes_for :photos, :allow_destroy => true

  def get_from_ext
     client = TinyTds::Client.new username: 'sa',
            password: 'Ve8Rohcier',
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
end

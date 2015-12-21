class Reservation < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :table
  belongs_to :user
  validate :visit_date_must_be_in_future



  has_many :meets, dependent: :delete_all
  accepts_nested_attributes_for :meets, :allow_destroy => true
  has_many :payments
  accepts_nested_attributes_for :payments, :allow_destroy => true

  # has_many :meet_users, through: :meets, class_name: 'User'

  after_create :create_ext_record
  after_update :update_reservation_ext
  after_destroy :destroy_reservation_ext
  before_save :update_end_visit_date

  enum status: [:wait, :approve, :deleted]

  def self.format_status(status)
    statuses = {'wait': 'Ожидается', 'approve': 'Подтверждено', 'deleted': 'Отменено'}
    statuses[status.to_sym]
  end
  scope :wait, -> { where(status: 0) }
  scope :approved, -> { where(status: 1) }
  scope :active, -> { where('reservations.status = 0 OR reservations.status = 1') }
  scope :deleted, -> { where(status: 2) }

  ransacker :containing_lounge_table,
          :formatter => ->(lounge) {
             results = joins(:table).where("tables.lounge_id = ?", lounge).map(&:id)
             results = results.present? ? results : nil
          }, splat_params: true do |parent|
      parent.table[:id]
  end


  def update_end_visit_date
    if self.user.role == 'vip'
      self.end_visit_date = self.visit_date + 2.hours + 30.minutes
    else
      self.end_visit_date = self.visit_date + 1.hours + 30.minutes
    end
  end
  def create_ext_record
    if self.table.try(:number) && self.user.idrref
      resp = SoapService.call(:reserve_save, message: {
        'КодСтола' => self.table.number,
        'ДатаРезерва' => self.visit_date.strftime('%Y-%m-%dT%H:%M:%S'),
        'Статус' => 'Активен',
        'Комментарий' => '',
        'Дата' => Time.zone.now.strftime('%Y-%m-%dT%H:%M:%S'),
        'Телефон' => self.user.phone,
        'Время' => self.duration.to_f
      })
      if resp[:reserve_save_response][:return] != '-1' && resp[:reserve_save_response][:return] != 'busy'
        self.code = resp[:reserve_save_response][:return]
        self.idrref = binary_to_string(find_from_ext_by_code()[:_IDRRef])
        self.save

        if self.user.idrref
          client = TinyTds::Client.new username: 'sa',
                  password: 'Ve8Rohcier',
                  host: '176.112.198.251',
                  port: 1433,
                  database: 'uhp_demo1',
                  azure:false

            idrref_binary = string_to_binary(self.user.idrref)
            reserv_idrref_binary = string_to_binary(self.idrref)
            query = """
            UPDATE [dbo].[_Document74] SET [_Fld1661RRef] = #{idrref_binary} WHERE [_IDRRef] = #{reserv_idrref_binary}
            """
            results = client.execute query
            results.do
        end


      else
        self.destroy()
      end
    end
  end

  def string_to_binary(value)
    "0x#{value}"
  end

  def get_from_ext
    client = TinyTds::Client.new username: 'sa',
            password: 'Ve8Rohcier',
            host: '176.112.198.251',
            port: 1433,
            database: 'uhp_demo1',
            azure:false
    idrref_binary = string_to_binary(self.idrref)
    query = """
    EXEC sp_executesql N'SELECT  [_document74].* FROM [_document74]
    WHERE [_document74].[_IDRRef] = #{idrref_binary}'
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

  def get_status_from_ext
    reservation_ext = self.get_from_ext()
    client = TinyTds::Client.new username: 'sa',
            password: 'Ve8Rohcier',
            host: '176.112.198.251',
            port: 1433,
            database: 'uhp_demo1',
            azure:false
    idrref_status_binary = binary_to_string(reservation_ext['_Fld1048RRef'])
    query = """
    EXEC sp_executesql N'SELECT  [_enum113].* FROM [_enum113]
    WHERE [_enum113].[_IDRRef] = 0x#{idrref_status_binary}'
    """
    results = client.execute query
    rows = []
    results.each do |row|
      rows.push row
    end
    if rows.length != 0
      return rows[0]['_EnumOrder'].to_i
    end
  end

  def binary_to_string(value)
    if value.length == 16
      value = value.unpack('C*').map{ |b| "%02X" % b }.join('')
    else
      value =~ /[^[:xdigit:]]/ ? value : [value].pack('H*')
    end
  end

  def find_from_ext_by_code
    ReservationExt.where(_Number: self.code).first
  end

  def update_reservation_ext
    # КодСтола,ДатаРезерва,Статус,Комментарий, Дата, Номер
    if self.table.try(:number) && self.code && self.status_changed?
      new_status = 'Активен'
      if self.status == 'deleted' || self.status == 2
        new_status = 'Отменен'
      end

      resp = SoapService.call(:reserve_edit, message: {
        'КодСтола' => self.table.number,
        'ДатаРезерва' => self.visit_date.strftime('%Y-%m-%dT%H:%M:%S'),
        'Статус' => new_status,
        'Комментарий' => '',
        'Дата' => Time.zone.now.strftime('%Y-%m-%dT%H:%M:%S'),
        'Номер' => self.code
      })
    end
  end

  def destroy_reservation_ext
    # КодСтола,ДатаРезерва,Статус,Комментарий, Дата, Номер
    if self.table.try(:number) && self.code
      resp = SoapService.call(:reserve_edit, message: {
        'КодСтола' => self.table.number,
        'ДатаРезерва' => self.visit_date.strftime('%Y-%m-%dT%H:%M:%S'),
        'Статус' => 'Отменен',
        'Комментарий' => '',
        'Дата' => Time.zone.now.strftime('%Y-%m-%dT%H:%M:%S'),
        'Номер' => self.code
      })
    end
  end
private
  # Валидатор для проверки даты бронирования
  # Дата должна быть больше текущей
  def visit_date_must_be_in_future
    errors.add(:visit_date, 'reservation.past_date') if visit_date < DateTime.now
  end
end

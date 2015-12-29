class User < ActiveRecord::Base
  # has_and_belongs_to_many :bonuses, class_name: 'Bonus'
  # has_and_belongs_to_many :penalties

  establish_connection Rails.env.to_sym

  has_many :skills_users, class_name: 'SkillsUsers', dependent: :delete_all
  has_many :skills, through: :skills_users
  accepts_nested_attributes_for :skills_users, :allow_destroy => true

  has_many :penalties_user, dependent: :delete_all
  has_many :penalties, through: :penalties_user
  accepts_nested_attributes_for :penalties_user, :allow_destroy => true

  has_many :achievements_user, dependent: :delete_all
  has_many :achievements, through: :achievements_user
  accepts_nested_attributes_for :achievements_user, :allow_destroy => true

  has_many :bonus_user, class_name: 'BonusUser', dependent: :delete_all
  has_many :bonuses, through: :bonus_user, class_name: 'Bonus'
  accepts_nested_attributes_for :bonus_user, :allow_destroy => true

  has_many :payments, dependent: :delete_all
  has_many :reservations, dependent: :delete_all
  has_many :works, dependent: :delete_all

  belongs_to :lounge

  validates :level, :numericality => { :less_than_or_equal_to => 30, greater_than_or_equal_to: 0 }
  validates :experience, :numericality => { greater_than_or_equal_to: 0 }
  validates :skill_point, :numericality => { greater_than_or_equal_to: 0 }
  validate :birthdate_must_be_18_age

  mount_uploader :avatar, AvatarUploader

  enum role: [:user, :admin, :vip, :hookmaster, :franchiser]
  after_initialize :set_default_role, if: :new_record?

  attr_accessor :hook_idrref
  attr_accessor :remove_avatar


  def set_default_role
    self.role ||= :user
  end

  def is_admin?
    self.role == 'admin'
  end

  def is_hookmaster?
    self.role == 'hookmaster'
  end

  def is_client?
    self.role == 'user' || self.role == 'vip'
  end
  def is_franchiser?
    self.role == 'franchiser'
  end

  def is_administrative?
    self.is_franchiser? || self.is_hookmaster?
  end

  def send_confirmation_token_to_phone
    if self.phone_token.nil?
      self.phone_token = 4.times.map { Random.rand(9) }.join
    end
    SMSService.send(self.phone, "Код подтверждения: #{self.phone_token}")
    self.code_sent_at = DateTime.now
    self.save
  end

  scope :clients, -> { where.not(role: 3).where.not(role: 1) }
  scope :hookmasters, -> { where(role: 3) }

  before_save :set_auth_token
  after_save :check_for_achievements, :update_user_ext
  after_create :create_user_ext

  def birthdate_must_be_18_age
    # if self.confirmed_at.present?
      # errors.add(:birthdate, 'Возраст меньше 18 лет') if (DateTime.parse(self.birthdate.to_s) > Date.today - 18.years)
    # end
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
  def self.binary_to_string(value)
    if value
      if value.length == 16
        value = value.unpack('C*').map{ |b| "%02X" % b }.join('')
      else
        value =~ /[^[:xdigit:]]/ ? value : [value].pack('H*')
      end
    end
  end







  def to_s
    "#{self.name} (#{self.phone})"
  end

  # Проверка на выполнение достижений связанных с юзером
  def check_for_achievements
    if self.is_client?
      self.check_for_open_profile_achievement()
      self.check_for_izobretatelnost_achievement()
    end
  end

  # TODO: MAKE SPEC
  def set_auth_token
    self.auth_token = SecureRandom.hex if self.auth_token.nil?
  end







  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable # , :validatable:confirmable

  validates :phone, presence: true, uniqueness: true
  validates_presence_of :password, if: :password_required?
  # validates :email, uniqueness: true

  # protected

  # Checks whether a password is needed or not. For validations only.
  # Passwords are always required if it's a new record, or if the password
  # or confirmation are being set somewhere.
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end


  def total_experience
    if self.role == 'hookmaster'
      # Оборот всех заведений
      payments = Payment.all.order(:created_at).group_by { |t| t.payed_at.beginning_of_day }

      total_amount = 0
      payments.sort.each do |day, ps|
        month_amount = ps.map(&:amount).reduce(0) { |p, sum| sum += p }
        month_works_count = Work.where('work_at >= ? AND work_at < ?', day.beginning_of_day, day.end_of_day).count
        user_works_count =  Work.where(user_id: self.id).where('work_at >= ? AND work_at < ?', day.beginning_of_day, day.end_of_day).count
        if month_works_count > 0 && user_works_count > 0
          total_amount += (month_amount / month_works_count)
        end
      end

      return total_amount
    else
      return self.experience
    end
  end

  def need_to_levelup
    if self.role == 'hookmaster'
      if self.current_level <= 10
        return 5225 - (self.total_experience - 5225 * (self.current_level - 1) )
      end
    else
      levels_cost = [0, 6000, 19200, 28800, 38400, 48000]

      need = levels_cost[self.level]
      need - self.experience + levels_cost[0..self.level - 1].reduce(0) { |lc, sum| sum += lc  }
    end
  end




  def percents_exp
    if self.role == 'hookmaster'
      0
    else
      if self.experience > 0
        levels_cost = [0, 6000, 19200, 28800, 38400, 48000]
        have_work_exp = self.experience - levels_cost[0..self.level-1].reduce(0) { |lc, sum| sum += lc  }
        if have_work_exp > 0
          percents_exp = (have_work_exp * 100 / (levels_cost[self.level])).to_i
        else
          0
        end
      else
        0
      end
    end
  end

  def current_level
    if self.role == 'hookmaster'
      grade_one_rate = 5225
      grade_one_cost = grade_one_rate * 10
      grade_two_rate = 15674
      grade_two_cost = grade_one_cost + grade_two_rate * 10
      grade_three_rate = 31347
      grade_three_cost = grade_one_cost + grade_two_cost + (grade_three_rate * 10)


      if self.total_experience <= grade_one_cost
        return (self.total_experience / grade_one_rate).to_i + 1
      elsif self.total_experience <= grade_two_cost
        current_exp = self.total_experience
        result_exp = current_exp - grade_one_cost
        return (result_exp / grade_two_rate).to_i + 10
      elsif self.total_experience <= grade_three_cost
        current_exp = self.total_experience
        result_exp = current_exp - grade_two_cost
        return (result_exp / grade_two_rate).to_i + 20
      else
        30
      end
    else
      self.level
    end
  end



  #### Методы клиента

  # Начислить опыт из платежа
  def add_exp_from_payment(amount)
    levels_cost = [0, 6000, 19200, 28800, 38400, 48000]

    self.experience += amount
    need_exp_to_levelup = levels_cost[0..self.level].reduce(0) { |lc, sum| sum += lc  }
    if self.experience >= need_exp_to_levelup
      self.level += 1
      self.skill_point += 1
    end
    self.save
  end

  # Получить платежи клиента
  def get_payments_from_ext
    client = TinyTds::Client.new username: 'sa',
            password: 'Ve8Rohcier',
            host: '176.112.198.251',
            port: 1433,
            database: 'uhp_demo1',
            azure:false

      idrref_binary = string_to_binary(self.idrref)
      idrref_binary = string_to_binary('A988D43D7E29EA8F11E5961EEED895B2')
      query = """
      EXEC sp_executesql N'SELECT  [_accumrg1568].* FROM [_accumrg1568]
      WHERE [_accumrg1568].[_Fld1663rref] = #{idrref_binary}'
      """
      results = client.execute query
      rows = []
      results.each do |row|
        rows.push row
      end
      return rows
  end

  # Получить запись клиента из 1С
  def get_user_ext
    client = TinyTds::Client.new username: 'sa',
            password: 'Ve8Rohcier',
            host: '176.112.198.251',
            port: 1433,
            database: 'uhp_demo1',
            azure:false

      idrref_binary = string_to_binary(self.idrref)
      query = """
      EXEC sp_executesql N'SELECT  [_reference42].* FROM [_reference42]
      WHERE [_reference42].[_IDRRef] = #{idrref_binary}'
      """
      results = client.execute query
      rows = []
      results.each do |row|
        rows.push row
      end
      return rows[0]
  end

  # Найти в 1С по номеру телефона
  def get_from_ext
    UserExt.where(_Fld496: self.phone).first
  end
  def create_user_ext
    puts 'create_user_ext'
    if self.role != 'hookmaster'
      SoapService.call(:create_customer, message: { 'Name' => self.name, 'Tel' => self.phone })
      user_ext = self.get_from_ext()
      if user_ext && user_ext._IDRRef
        self.idrref = binary_to_string(user_ext._IDRRef)
        self.save!
      end
    end
  end

  def update_user_ext
    if self.idrref && self.birthdate_changed? && self.role != 'hookmaster'
      client = TinyTds::Client.new username: 'sa',
              password: 'Ve8Rohcier',
              host: '176.112.198.251',
              port: 1433,
              database: 'uhp_demo1',
              azure:false

        idrref_binary = string_to_binary(self.idrref)
        query = """
        UPDATE [dbo].[_Reference42] SET [_Fld1664] = '"+self.birthdate.strftime('%Y-%m-%d %H:%M:%S')+"' WHERE [_IDRRef] = #{idrref_binary}
        """
        results = client.execute query
        results.do
    end
  end

  # Ачимент "Открытость"
  # Заполните свой профиль на 100%
  def check_for_open_profile_achievement

    if self.hobby.present? && self.employe.present? && self.work_company.present? && self.city.present?
      achievement = Achievement.find_by_key('otkrytost')
      if !achievement
        achievement = Achievement.create(name: 'Открытость')
      end
      if !AchievementsUser.where(user_id: self.id, achievement_id: achievement.id).present?
          AchievementsUser.create!(user: self, achievement: achievement)
      end
    end
  end
  # Ачимент "Изобретательность"
  # Проведите мероприятие
  def check_for_izobretatelnost_achievement
    achievement = nil
    if self.party_count > 0
      case self.party_count
      when 1
        achievement = Achievement.find_by_key('izobretatelnost-i')
        if !achievement
          achievement = Achievement.create(name: 'Изобретательность I')
        end
      when 2
        achievement = Achievement.find_by_key('izobretatelnost-ii')
        if !achievement
          achievement = Achievement.create(name: 'Изобретательность II')
        end
      when 3
        achievement = Achievement.find_by_key('izobretatelnost-iii')
        if !achievement
          achievement = Achievement.create(name: 'Изобретательность III')
        end
      when 4
        achievement = Achievement.find_by_key('izobretatelnost-iv')
        if !achievement
          achievement = Achievement.create(name: 'Изобретательность IV')
        end
      when 5
        achievement = Achievement.find_by_key('izobretatelnost-v')
        if !achievement
          achievement = Achievement.create(name: 'Изобретательность V')
        end
      end
    end
    if achievement
      if !AchievementsUser.where(user_id: self.id, achievement_id: achievement.id).present?
          AchievementsUser.create!(user: self, achievement: achievement)
      end
    end
  end

  #### Методы кальянщика

  # Получить запись кальянщика из 1С
  def get_hookmaster_ext
    HookmasterExt.where(_IDRRef: User.binary_to_string(self.idrref)).first
  end

end

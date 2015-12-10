class User < ActiveRecord::Base
  # has_and_belongs_to_many :bonuses, class_name: 'Bonus'
  # has_and_belongs_to_many :penalties

  establish_connection Rails.env.to_sym

  has_many :skills_users, class_name: 'SkillsUsers'
  has_many :skills, through: :skills_users
  accepts_nested_attributes_for :skills_users, :allow_destroy => true

  has_many :penalties_user
  has_many :penalties, through: :penalties_user
  accepts_nested_attributes_for :penalties_user, :allow_destroy => true

  has_many :achievements_user
  has_many :achievements, through: :achievements_user
  accepts_nested_attributes_for :achievements_user, :allow_destroy => true

  has_many :bonus_user, class_name: 'BonusUser'
  has_many :bonuses, through: :bonus_user, class_name: 'Bonus'
  accepts_nested_attributes_for :bonus_user, :allow_destroy => true

  has_many :payments, dependent: :delete_all
  has_many :reservations, dependent: :delete_all

  mount_uploader :avatar, AvatarUploader

  enum role: [:user, :admin, :vip, :hookmaster]
  after_initialize :set_default_role, if: :new_record?

  before_save :set_auth_token
  after_save :check_for_achievements

  scope :clients, -> { where.not(role: 3).where.not(role: 1) }
  scope :hookmasters, -> { where(role: 3) }

  # after_create :create_user_ext

  def to_s
    "#{self.name} (#{self.phone})"
  end

  # Проверка на выполнение достижений связанных с юзером
  def check_for_achievements
    self.check_for_open_profile_achievement()
  end

  # TODO: MAKE SPEC
  def set_auth_token
    self.auth_token = SecureRandom.hex if self.auth_token.nil?
  end

  # Ачимент "Открытость"
  # Заполните свой профиль на 100%
  def check_for_open_profile_achievement
    # raise Achievement.find_by_key('open_profile').inspect
    if self.email.present? && self.hobby.present? && self.employe.present? && self.work_company.present? && self.city.present?

      achievement = Achievement.find_by_key('otkrytost')
      if !achievement
        achievement = Achievement.create(name: 'Открытость')
      end
      if !AchievementsUser.where(user_id: self.id, achievement_id: achievement.id).present?
          AchievementsUser.create!(user: self, achievement: achievement)
      end
    end

  end

  def set_default_role
    self.role ||= :user
  end

  def is_admin?
    self.role == 'admin'
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
      payments = Payment.all.order(:created_at).group_by { |t| t.created_at.beginning_of_day }

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
      first_level = 6000
      if self.level == 1
        need = first_level
      else
        need = ((self.level) * first_level * 1.25 ** 2.1).round
      end
      need - self.experience
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

  def visits
    visits_ext = ExtService.execute("select * from _AccumRg1568 WHERE _fld1663rref = E'#{self.idrref}'")
    if visits_ext.ntuples > 0
      visits_ext
    else
      []
    end
  end

  def create_user_ext
    _idrref = SecureRandom.hex[0..10].bytes#.join('\\')
    result = ExtService.execute('select _code from _reference42 order by _code DESC limit 1;')
    _code = 0000000001
    if result.ntuples > 0
      _code = result[0]['_code'].strip.to_i + 1
    end

    _description = self.name
    _fld496 = self.phone

    query = "INSERT INTO _reference42 \
    (_idrref, _version, _marked, _ismetadata, _parentidrref, _folder, _code, _description, _fld494, _fld495, _fld496) VALUES \
    ('#{_idrref}', 0,   false,   false,   '\\000\\000\\000\\000\\000', true, '#{_code}', '#{_description}', '',  false, '#{_fld496}')"
    ExtService.execute query
    self.idrref = _idrref
    self.save
  end
end

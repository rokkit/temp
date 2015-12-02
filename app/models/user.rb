class User < ActiveRecord::Base

  establish_connection Rails.env.to_sym

  has_many :skills_users, class_name: 'SkillsUsers'
  has_many :skills, through: :skills_users

  has_many :achievements_user
  has_many :achievements, through: :achievements_user

  has_many :payments
  has_many :reservations

  mount_uploader :avatar, AvatarUploader

  enum role: [:user, :admin, :vip]
  after_initialize :set_default_role, if: :new_record?

  before_save :set_auth_token
  after_save :check_for_achievements

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
    if self.email.present? && self.avatar.present?
      achievement = Achievement.find_by_key('open_profile')
      if !achievement
        achievement = Achievement.create(name: 'Открытость')
      end
      AchievementsUser.create!(user: self, achievement: achievement)
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
    visits_ext = self.visits
    if visits_ext.length > 0
      return visits_ext.map { |p| p['_fld1574'] }.reduce(0) { |p, i| i += p }
    else
      return 0
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

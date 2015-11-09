class User < ActiveRecord::Base
  has_many :skills_users, class_name: 'SkillsUsers'
  has_many :skills, through: :skills_users

  has_many :achievements_user
  has_many :achievements, through: :achievements_user

  has_many :payments

  mount_uploader :avatar, AvatarUploader

  enum role: [:user, :admin]
  after_initialize :set_default_role, if: :new_record?

  after_save :check_for_achievements

  # Проверка на выполнение достижений связанных с юзером
  def check_for_achievements
    self.check_for_open_profile_achievement()
  end

  # Ачимент "Открытость"
  # Заполните свой профиль на 100%
  def check_for_open_profile_achievement
    # raise Achievement.find_by_key('open_profile').inspect
    AchievementsUser.create!(user: self, achievement: Achievement.find_by_key('open_profile')) if self.email.present? &&
       self.avatar.present?
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

  protected

  # Checks whether a password is needed or not. For validations only.
  # Passwords are always required if it's a new record, or if the password
  # or confirmation are being set somewhere.
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end

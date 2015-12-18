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
  has_many :works, dependent: :delete_all


  mount_uploader :avatar, AvatarUploader

  enum role: [:user, :admin, :vip, :hookmaster]
  after_initialize :set_default_role, if: :new_record?

  before_save :set_auth_token
  after_save :check_for_achievements

  scope :clients, -> { where.not(role: 3).where.not(role: 1) }
  scope :hookmasters, -> { where(role: 3) }

  after_create :create_user_ext


  # scope :lounge_eq, -> (lounge) { joins(:table).where("tables.lounge_id = ?", lounge) }
  # ransacker :lounge_table_eq,
  #         :formatter => ->(lounge) {
  #            joins(:table).where("tables.lounge_id = ?", lounge).map(&:id)
  #         } do |parent|
  #     parent.table[:id]
  # end

  def to_s
    "#{self.name} (#{self.phone})"
  end

  # Проверка на выполнение достижений связанных с юзером
  def check_for_achievements
    self.check_for_open_profile_achievement()
    self.check_for_izobretatelnost_achievement()
  end

  # TODO: MAKE SPEC
  def set_auth_token
    self.auth_token = SecureRandom.hex if self.auth_token.nil?
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

  def percents_exp
    if self.role == 'hookmaster'
    else
      if self.experience > 0
        levels_cost = [0, 6000, 19200, 28800, 38400, 48000]
        have_work_exp = self.experience - levels_cost[0..self.level-1].reduce(0) { |lc, sum| sum += lc  }
        if have_work_exp > 0
          percents_exp = (have_work_exp * 100 / (levels_cost[self.level])).to_i
        else
          0
        end
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

  def visits
    visits_ext = ExtService.execute("select * from _AccumRg1568 WHERE _fld1663rref = E'#{self.idrref}'")
    if visits_ext.ntuples > 0
      visits_ext
    else
      []
    end
  end

  def create_user_ext
    SoapService.call(:create_customer, message: { 'Name' => self.name, 'Tel' => self.phone })
    # self.idrref = _idrref
    # self.save
  end
end

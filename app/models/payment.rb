class Payment < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :user
  belongs_to :table

  validates :amount, :user, presence: true

  after_save :add_exp_to_user

  def add_exp_to_user
    self.user.experience += self.amount.to_i# * 0.01
    # Проверить количество опыта, не достигло ли оно следующего уровня
    # если достигло, то увеличить уровень и дать одно очко навыка
    current_level = self.user.level
    current_skill_points  = self.user.skill_point

    self.user.level ||= 1
    if self.user.experience >= 6000 && self.user.experience < 19200
      self.user.update_attributes level: 2, skill_point: current_skill_points + 1
    elsif self.user.experience >= 19200 && self.user.experience < 28800
      self.user.update_attributes level: 3, skill_point: current_skill_points + 1
    end
  end
end

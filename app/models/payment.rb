class Payment < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :user

  validates :amount, :user, presence: true

  after_save :add_exp_to_user

  def add_exp_to_user
    self.user.experience += self.amount * 0.01

    # Проверить количество опыта, не достигло ли оно следующего уровня
    # если достигло, то увеличить уровень и дать одно очко навыка
    if self.user.experience >= 1000
      self.user.level += 1
      self.user.skill_point += 1
    end
    self.user.save
    #code
  end
end

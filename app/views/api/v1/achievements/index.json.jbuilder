json.array!(@achievements) do |achievement|
  json.extract! achievement, :id, :name, :description
  json.image achievement.image_url
  json.open AchievementsUser.where(user_id: current_user.id,
                                   achievement_id: achievement.id).first.present?
end

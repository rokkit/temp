json.extract! achievement, :id, :name, :description
json.image achievement.image_url
json.open achievement.open?(current_user.id)
json.viewed AchievementsUser.where(achievement_id: achievement.id, user_id: current_user.id).first.try(:viewed) || false

json.extract! achievement, :id, :name, :description
json.image achievement.image_url
json.open achievement.open?(current_user.id)

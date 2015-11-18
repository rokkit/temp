require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe "slug generation" do
    it "generate slug for new record" do
      achievement = Achievement.create name: 'Name'
      expect(achievement.key).to eq 'Name'.parameterize
    end
  end
end

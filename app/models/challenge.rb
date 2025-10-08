class Challenge < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :participations
  has_many :users, through: :participations
  has_many :progress_entries
  has_many :challenge_badges
  has_many :badges, through: :challenge_badges
end


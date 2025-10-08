class Badge < ApplicationRecord
  has_many :challenge_badges
  has_many :challenges, through: :challenge_badges
  has_many :user_badges
  has_many :users, through: :user_badges
end


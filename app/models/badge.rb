class Badge < ApplicationRecord
  has_many :challenge_badges, dependent: :destroy
  has_many :challenges, through: :challenge_badges
  has_many :user_badges, dependent: :destroy
  has_many :users, through: :user_badges

  validates :name, presence: true, uniqueness: true
  validates :badge_type, presence: true
  validates :description, presence: true
  validates :requirement, presence: true
end
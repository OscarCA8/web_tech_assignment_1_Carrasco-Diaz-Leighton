class User < ApplicationRecord
  has_secure_password

  has_many :created_challenges, class_name: "Challenge", foreign_key: "creator_id"
  has_many :participations
  has_many :challenges, through: :participations
  has_many :progress_entries
  has_many :notifications
  has_many :user_badges
  has_many :badges, through: :user_badges
end


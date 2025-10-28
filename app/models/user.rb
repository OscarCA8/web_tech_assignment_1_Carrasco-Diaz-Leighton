class User < ApplicationRecord
  has_many :participations, dependent: :destroy
  has_many :challenges, through: :participations
  has_many :notifications, dependent: :destroy
  has_many :progress_entries, dependent: :destroy
  has_many :user_badges, dependent: :destroy
  has_many :badges, through: :user_badges

  has_secure_password

  validates :name, presence: true, length: { minimum: 3 }
  validates :password, presence: true, length: { minimum: 4 }, if: :password_digest_changed?
  validates :birthday, presence: true
  validates :nationality, presence: true
  validates :gender, inclusion: { in: %w[M F O], message: "must be M, F, or O" }
end
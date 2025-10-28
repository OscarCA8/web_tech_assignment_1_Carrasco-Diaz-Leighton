class UserBadge < ApplicationRecord
  belongs_to :user
  belongs_to :badge

  validates :awarded_at, presence: true
  validates :user_id, uniqueness: { scope: :badge_id, message: "already has this badge" }
end
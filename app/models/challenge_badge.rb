class ChallengeBadge < ApplicationRecord
  belongs_to :challenge
  belongs_to :badge

  validates :requirement, presence: true
  validates :badge_id, uniqueness: { scope: :challenge_id, message: "is already linked to this challenge" }
end
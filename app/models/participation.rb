class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :challenge

  validates :user_id, uniqueness: { scope: :challenge_id, message: "is already participating in this challenge" }
  validates :date_start, presence: true
  validate  :date_within_challenge

  def date_within_challenge
    if challenge && (date_start < challenge.start_day || date_start > challenge.end_day)
      errors.add(:date_start, "must be within the challenge period")
    end
  end
end

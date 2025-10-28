class ProgressEntry < ApplicationRecord
  belongs_to :challenge
  belongs_to :user

  validates :date, presence: true
  validates :points, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { minimum: 5 }

  validate :date_within_challenge

  def date_within_challenge
    if challenge && (date < challenge.start_day || date > challenge.end_day)
      errors.add(:date, "must be within challenge dates")
    end
  end
end

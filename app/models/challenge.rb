class Challenge < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :participations, dependent: :destroy
  has_many :users, through: :participations
  has_many :progress_entries, dependent: :destroy
  has_many :challenge_badges, dependent: :destroy
  has_many :badges, through: :challenge_badges

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :start_day, presence: true
  validates :end_day, presence: true
  validate  :end_after_start

  def end_after_start
    if start_day && end_day && end_day <= start_day
      errors.add(:end_day, "must be after the start day")
    end
  end
end

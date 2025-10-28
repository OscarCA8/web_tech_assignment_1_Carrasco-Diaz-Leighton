class Notification < ApplicationRecord
  belongs_to :user

  validates :message, presence: true, length: { minimum: 5 }
  validates :read, inclusion: { in: [true, false] }
end

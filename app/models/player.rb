class Player < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :user, presence: true
end

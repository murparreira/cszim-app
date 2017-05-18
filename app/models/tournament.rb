class Tournament < ApplicationRecord
  has_many :participants
  has_many :teams, through: :participants
  has_many :rounds
end

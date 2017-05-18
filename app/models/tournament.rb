class Tournament < ApplicationRecord
  has_many :teams, through: :participants
  has_many :participants
  accepts_nested_attributes_for :participants, reject_if: :all_blank, allow_destroy: true

  has_many :rounds
end

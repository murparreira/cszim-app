class Team < ApplicationRecord
  has_many :players
  has_many :users, through: :players

  has_many :players
  accepts_nested_attributes_for :players, reject_if: :all_blank, allow_destroy: true
end

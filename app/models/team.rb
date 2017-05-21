class Team < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :users, through: :players
  accepts_nested_attributes_for :players, reject_if: :all_blank, allow_destroy: true

  validates :nome, presence: true, uniqueness: true
end

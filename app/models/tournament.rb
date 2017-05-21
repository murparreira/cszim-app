class Tournament < ApplicationRecord
  has_many :rounds, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :teams, through: :participants
  accepts_nested_attributes_for :participants, reject_if: :all_blank, allow_destroy: true

  validates :nome, presence: true

end

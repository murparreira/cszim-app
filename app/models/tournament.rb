class Tournament < ApplicationRecord
  has_many :map_bans, dependent: :destroy
  accepts_nested_attributes_for :map_bans, reject_if: :all_blank, allow_destroy: true
  has_many :rounds, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :teams, through: :participants
  accepts_nested_attributes_for :participants, reject_if: :all_blank, allow_destroy: true

  validates :nome, presence: true

  scope :oficiais, -> { where(oficial: true) }
  scope :ultimos, -> { order(id: :desc).limit(5) }
end

class Participant < ApplicationRecord
  belongs_to :team
  accepts_nested_attributes_for :team
  belongs_to :tournament

  validates :team, presence: true
end

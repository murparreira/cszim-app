class Team < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :users, through: :players
  accepts_nested_attributes_for :players, reject_if: :all_blank, allow_destroy: true

  validates :nome, presence: true, uniqueness: true

  def self.safe_find_or_create_by(*args, &block)
    find_or_create_by *args, &block
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def demos
    Demo.where("time_vencedor_id = ? OR time_perdedor_id = ?", self.id, self.id)
  end
end

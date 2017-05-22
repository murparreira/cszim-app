class MapBan < ApplicationRecord
  belongs_to :tournament
  belongs_to :map

  validates :map, presence: true
end

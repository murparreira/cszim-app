class PlayerStatistic < ApplicationRecord

  belongs_to :demo
  belongs_to :user
  has_many :player_kills

end

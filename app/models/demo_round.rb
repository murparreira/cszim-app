class DemoRound < ApplicationRecord

  has_many :demo_round_kills
  belongs_to :demo

end

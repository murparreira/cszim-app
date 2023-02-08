class Demo < ApplicationRecord

  has_many :player_statistics
  has_many :demo_rounds
  belongs_to :map

end

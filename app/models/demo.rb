class Demo < ApplicationRecord

  has_many :player_statistics
  belongs_to :map

end

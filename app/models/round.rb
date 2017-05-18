class Round < ApplicationRecord
    belongs_to :map
    belongs_to :tournament

    has_one :winner
    has_one :loser

    has_many :statistics
end

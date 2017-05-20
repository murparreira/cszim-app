class Statistic < ApplicationRecord
    belongs_to :round
    belongs_to :user

    attr_accessor :nome

    def ratio
      (kills.to_f/deaths.to_f).round(2)
    end
end

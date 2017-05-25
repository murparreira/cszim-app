class Statistic < ApplicationRecord
    belongs_to :round
    belongs_to :user

    attr_accessor :nome

    def ratio
      ratio = (kills.to_f/deaths.to_f).round(2)
      return 1 if ratio.infinite?
      return 0 if ratio.nan?
      ratio
    end

    def kills
      super || 0
    end

    def deaths
      super || 0
    end
end

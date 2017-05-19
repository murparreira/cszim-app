class Statistic < ApplicationRecord
    belongs_to :round
    belongs_to :user

    attr_accessor :nome
end

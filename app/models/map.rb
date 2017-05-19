class Map < ApplicationRecord
    dragonfly_accessor :imagem

    has_many :rounds

    validates :nome, :sigla, presence: true
end

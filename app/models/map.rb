class Map < ApplicationRecord
    dragonfly_accessor :imagem

    validates :nome, :sigla, presence: true
end

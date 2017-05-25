class Map < ApplicationRecord
    dragonfly_accessor :imagem

    has_many :rounds

    validates :nome, :sigla, presence: true

    scope :ativos, -> { where(ativo: true) }
end

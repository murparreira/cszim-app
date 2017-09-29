class Map < ApplicationRecord
  dragonfly_accessor :imagem
  belongs_to :game
  has_many :rounds
  validates :nome, :sigla, presence: true
  scope :ativos, -> { where(ativo: true) }
end

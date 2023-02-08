class Map < ApplicationRecord
  dragonfly_accessor :imagem
  belongs_to :game
  has_many :rounds
  has_many :demos
  has_many :demo_rounds, through: :demos

  validates :nome, :sigla, presence: true
  scope :ativos, -> { where(ativo: true) }
end

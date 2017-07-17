class Team < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :users, through: :players
  accepts_nested_attributes_for :players, reject_if: :all_blank, allow_destroy: true

  validates :nome, presence: true, uniqueness: true

  before_validation :criar_nome_aleatorio

  def criar_nome_aleatorio
    player_names = ""
    self.players.each do |player|
      player_names += player.user.nome.first
    end
    self.nome = "#{rand(100)} #{player_names}"
  end

  def self.safe_find_or_create_by(*args, &block)
    find_or_create_by *args, &block
  rescue ActiveRecord::RecordNotUnique
    retry
  end
end

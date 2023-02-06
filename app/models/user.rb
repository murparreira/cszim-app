class User < ApplicationRecord
	include Filterable

  has_secure_password

	validates :nome, :login, presence: true
  validates :login, uniqueness: true, on: :create
  validates :password, presence: true, length: { minimum: 5 }, allow_nil: true

  has_many :statistics, dependent: :destroy
  has_many :player_statistics, dependent: :destroy
  has_many :player_kills, through: :player_statistics
  has_many :demos, through: :player_statistics

  SENHA_PADRAO = "123abc"

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def total_kills
    player_statistics.sum :kills
  end

  def total_deaths
    player_statistics.sum :deaths
  end

  def total_ratio
    (total_kills.to_f/total_deaths.to_f).nan? ? 0.0 : (total_kills.to_f/total_deaths.to_f)
  end

end

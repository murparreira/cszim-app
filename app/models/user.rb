class User < ApplicationRecord
	include Filterable

  has_secure_password

	validates :nome, :login, presence: true
  validates :login, uniqueness: true, on: :create
  validates :password, presence: true, length: { minimum: 5 }, allow_nil: true

  has_many :statistics, dependent: :destroy

  SENHA_PADRAO = "123abc"

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

end

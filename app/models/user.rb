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
  has_many :players 
  has_many :teams, through: :players

  SENHA_PADRAO = "123abc"

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def total(statistic)
    player_statistics.sum(statistic)
  end

  def grouped_total(statistic, percent = false)
    total = total(statistic)/player_statistics.size
    total = total * 100 if percent
    total.round(2)
  end

  def armas
    player_kills.pluck(:weapon)
      .group_by {|weapon| weapon.itself}
      .transform_values {|weapon| weapon.count}
  end

  def besto_friend
    times_vencedores = Demo.all.map do |demo|
      demo.time_vencedor.user_ids
    end
    h = {}
    times_vencedores.each do |time|
      User.where.not(id: id).each do |friendo|
        if (time - [friendo.id, id]).empty?
          if h[friendo.id]
            h[friendo.id] += 1
          else
            h[friendo.id] = 1
          end
        end
      end
    end
    h
  end

end

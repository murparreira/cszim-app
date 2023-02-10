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
      .delete_if {|weapon| weapon == 'World'}
      .group_by {|weapon| weapon.itself}
      .transform_values {|weapon| weapon.count}
      .sort_by {|weapon, kills| kills}
      .reverse!
  end

  def arma_favorita
    armas.max_by{|arma, kills| kills}
  end

  def besto_friendo
    besto_friendo_hash = User.where.not(id: id).to_h do |friendo|
      vitorias = ActiveRecord::Base.connection.exec_query(
        "SELECT COUNT(subquery.id) FROM (
          SELECT d.id FROM demos d
          INNER JOIN teams tv ON d.time_vencedor_id = tv.id
          INNER JOIN players ptv ON ptv.team_id = tv.id
          WHERE ptv.user_id = #{friendo.id}
          INTERSECT
          SELECT d.id FROM demos d
          INNER JOIN teams tv ON d.time_vencedor_id = tv.id
          INNER JOIN players ptv ON ptv.team_id = tv.id
          WHERE ptv.user_id = #{id}) AS subquery"
      ).first['count']
      [friendo, vitorias]
    end.max_by{|friendo, vitorias| vitorias}
    besto_friendo_hash if besto_friendo_hash.last > 0
  end

  def worsto_friendo
    worsto_friendo_hash = User.where.not(id: id).to_h do |friendo|
      derrotas = ActiveRecord::Base.connection.exec_query(
        "SELECT COUNT(subquery.id) FROM (
          SELECT d.id FROM demos d
          INNER JOIN teams tv ON d.time_perdedor_id = tv.id
          INNER JOIN players ptv ON ptv.team_id = tv.id
          WHERE ptv.user_id = #{friendo.id}
          INTERSECT
          SELECT d.id FROM demos d
          INNER JOIN teams tv ON d.time_perdedor_id = tv.id
          INNER JOIN players ptv ON ptv.team_id = tv.id
          WHERE ptv.user_id = #{id}) AS subquery"
      ).first['count']
      [friendo, derrotas]
    end.max_by{|friendo, derrotas| derrotas}
    worsto_friendo_hash if worsto_friendo_hash.last > 0
  end

end

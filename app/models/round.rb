class Round < ApplicationRecord
    dragonfly_accessor :screenshot

    belongs_to :map
    belongs_to :tournament

    has_one :winner
    has_one :loser
    has_many :rankme_csgos, dependent: :destroy
    has_many :rankmes, dependent: :destroy

    belongs_to :ct_team, foreign_key: "ct_team_id", class_name: "Team"
    belongs_to :t_team, foreign_key: "t_team_id", class_name: "Team"

    has_many :statistics, dependent: :destroy

    def nome_mapa
      if map
        "#{map.nome} - #{map.sigla}"
      else
        "Não Informado"
      end
    end

    def nome_vencedor
      if winner && winner.team
        winner.team.nome
      else
        "Não Informado"
      end
    end

    def placar_vencedor
      if winner
        winner.valor_placar
      else
        "Não Informado"
      end
    end

    def lado_vencedor
      if winner
        winner.lado
      else
        "Não Informado"
      end
    end

    def nome_perdedor
      if loser && loser.team
        loser.team.nome
      else
        "Não Informado"
      end
    end

    def placar_perdedor
      if loser
        loser.valor_placar
      else
        "Não Informado"
      end
    end

    def lado_perdedor
      if loser
        loser.lado
      else
        "Não Informado"
      end
    end

    def loser_team_id(winner_team_id)
      array = tournament.teams.pluck(:id)
      array.delete(winner_team_id)
      array[0]
    end

end

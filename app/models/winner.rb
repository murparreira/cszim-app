class Winner < ApplicationRecord
    belongs_to :round
    belongs_to :team

    def valor_placar
      if placar
        placar
      else
        "Não Informado"
      end
    end
end

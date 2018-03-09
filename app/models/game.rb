class Game < ApplicationRecord

  has_many :maps

  def situacao_traduzida
    if ativo
      "<span class='tag is-success'>Jogo Ativo</span>".html_safe
    else
      "<span class='tag is-danger'>Jogo Inativo</span>".html_safe
    end
  end

end

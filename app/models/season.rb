class Season < ApplicationRecord

  def situacao_traduzida
    if ativo
      "<span class='tag is-success'>Temporada Ativa</span>".html_safe
    else
      "<span class='tag is-danger'>Temporada Finalizada</span>".html_safe
    end
  end

end

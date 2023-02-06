class ServerConfiguration < ApplicationRecord

  def situacao_traduzida
    if ativo
      "<span class='tag is-success'>Configuração Ativa</span>".html_safe
    else
      "<span class='tag is-danger'>Configuração Inativa</span>".html_safe
    end
  end

  def is_v1?
    version.downcase == 'v1'
  end

  def is_v2?
    version.downcase == 'v2'
  end

end

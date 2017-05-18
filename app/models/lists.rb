class Lists

  TIPOS_USUARIO = [:admin, :financeiro, :motorista]
  TIPOS_OPERACAO = [:+, :-]

  def self.lista_tipos_usuario
    list = TIPOS_USUARIO.map do |e|
      case e
      when :admin
        ["Administrador", e]
      when :financeiro
        ["Financeiro", e]
      when :motorista
        ["Motorista", e]
      end
    end
    list.unshift ["Selecione...", ""]
    list
  end

  def self.lista_operacao
    list = TIPOS_OPERACAO.map do |e|
      case e
      when :+
        ["+", e]
      when :-
        ["-", e]
      end
    end
    list
  end
end
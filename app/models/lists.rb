class Lists

  LADOS = ["ct", "t"]

  def self.lado_perdedor(lado_vencedor)
    LADOS.delete(lado_vencedor)
    LADOS[0]
  end

end

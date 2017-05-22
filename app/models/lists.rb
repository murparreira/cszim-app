class Lists

  def self.lado_perdedor(lado_vencedor)
    array = ["ct", "t"]
    array.delete(lado_vencedor)
    array[0]
  end

end

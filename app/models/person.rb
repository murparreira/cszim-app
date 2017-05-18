class Person < ApplicationRecord
	before_validation :normalizar_atributos

	has_one :user

	validates :nome, :documento, presence: true
	validates :documento, uniqueness: true, on: :create
  validate :data_nascimento_valida

	private
	def normalizar_atributos
		documento.gsub!(/[^0-9]/, '') if documento
		telefone.gsub!(/[^0-9]/, '') if telefone
  end

  def data_nascimento_valida
  	if data_nascimento.size > 0
      if data_nascimento.gsub("/", "").gsub("_", "").size != 8
  		  errors.add(:data_nascimento, "não é uma data válida")
      else
        Date.parse(data_nascimento) rescue errors.add(:data_nascimento, "não é uma data válida")
      end
    end
  end

end

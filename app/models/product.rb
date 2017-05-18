class Product < ApplicationRecord
  has_many :customers, through: :customer_products

	validates :nome, presence: true
	monetize :valor_centavos, :allow_nil => true
end

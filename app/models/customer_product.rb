class CustomerProduct < ApplicationRecord
	monetize :valor_centavos, :allow_nil => true
  	belongs_to :product

  	def self.by_product_by_customer(product_id, customer_id)
  		find_by(product_id: product_id, customer_id: customer_id)
  	end
end

class ReceiptPayment < ApplicationRecord
  has_one :receipt
  monetize :valor_total_centavos, :allow_nil => true
end

class PaymentType < ApplicationRecord
	validates :nome, presence: true
end

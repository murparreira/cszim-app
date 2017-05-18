class CustomerReceipt < ApplicationRecord
	belongs_to :customer
	belongs_to :receipt

	validates :customer_id, presence: true
end

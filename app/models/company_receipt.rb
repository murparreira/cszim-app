class CompanyReceipt < ApplicationRecord
	belongs_to :company
	belongs_to :customer
	belongs_to :receipt

	validates :customer_id, presence: true
  validates :company_id, presence: true
end

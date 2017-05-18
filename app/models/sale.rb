class Sale < ApplicationRecord
  belongs_to :user
	belongs_to :customer
  has_many :product_sales, autosave: true, dependent: :destroy
  validates_associated :product_sales
  accepts_nested_attributes_for :product_sales

  monetize :valor_total_centavos, :allow_nil => true

  validates :data_venda, presence: true
end

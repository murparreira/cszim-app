class Receipt < ApplicationRecord
	belongs_to :user
  belongs_to :customer
  monetize :valor_total_centavos, :allow_nil => true

  validates :data_recebimento, presence: true

  has_one :customer_receipt, autosave: true, dependent: :destroy
  validates_associated :customer_receipt
  has_one :company_receipt, autosave: true, dependent: :destroy
  validates_associated :company_receipt

  has_many :receipt_payments
  accepts_nested_attributes_for :receipt_payments, reject_if: :all_blank, allow_destroy: true
  
  def is_empresa?
    customer_receipt.nil?
  end

  def nome_cliente
    return customer_receipt.customer.nome if customer_receipt
    return company_receipt.customer.nome if company_receipt
  end

  def nome_empresa
    company_receipt.company.nome
  end

  def nome_cliente_empresa
    return nome_cliente if tipo_recebimento == 'customer'
    return nome_cliente << ' - Empresa: ' << company_receipt.company.nome if tipo_recebimento == 'company'
  end

  def id_cliente
    return customer_receipt.customer.id if customer_receipt
    return company_receipt.customer.id if company_receipt
  end
end

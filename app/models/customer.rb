class Customer < Person
  include PgSearch
  pg_search_scope :search_for, against: %i(nome numero documento)

  belongs_to :user
	has_many :sales
  has_many :receipts
	has_many :customer_receipts
  has_many :company_receipts
  has_many :companies, through: :customer_companies
  has_many :products, through: :customer_products

  has_many :customer_companies
  accepts_nested_attributes_for :customer_companies, reject_if: :all_blank, allow_destroy: true
  
  has_many :customer_products
  accepts_nested_attributes_for :customer_products, reject_if: :all_blank, allow_destroy: true

  enum sex: [ :masculino, :feminino ]

	monetize :bonificacao_pontualidade_centavos, :allow_nil => true
end

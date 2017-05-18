class Company < Person
  has_many :customers, through: :customer_companies
end

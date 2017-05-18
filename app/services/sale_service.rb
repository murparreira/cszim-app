class SaleService

  def self.create(params, id)
    sale = Sale.find(id)
    begin
      ActiveRecord::Base.transaction do
        valor_total = 0
        params[:product_sales].each do |product_sale|
          product = Product.find(product_sale[:product_id])
          valor_total += product.valor_centavos * product_sale[:quantidade].to_i
          variacao = 0
          if CustomerProduct.find_by(customer_id: params[:sale][:customer_id], product_id: product_sale[:product_id]).nil?
            variacao = 1
          else
            customer_product = CustomerProduct.find_by(customer_id: params[:sale][:customer_id], product_id: product_sale[:product_id])
            variacao = variacao.send(customer_product.operacao, customer_product.valor_centavos.to_i)
          end
          variacao = variacao * product_sale[:quantidade].to_i
          valor_total = valor_total + variacao
        end
        sale.update_attributes(:valor_total_centavos => valor_total)
        sale.product_sales.build(params[:product_sales])
        sale.save!
        sale
      end
    rescue Exception => e
      sale.errors.add(:base, "Ocorreram erros ao salvar o registro!")
      sale
    end
  end

end
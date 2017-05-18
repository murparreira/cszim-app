class ReceiptService

  def self.create(params, id, customer_id)
    begin
      ActiveRecord::Base.transaction do
        case params[:tipo_recebimento]
          when 'customer'
            customer_receipt = CustomerReceipt.new
            customer_receipt.receipt_id = id
            customer_receipt.customer_id = customer_id
            customer_receipt.save!
          when 'company'
            company_receipt = CompanyReceipt.new
            company_receipt.receipt_id = id
            company_receipt.company_id = params[:company_id]
            company_receipt.customer_id = customer_id
            company_receipt.save!
        end
      end
    rescue Exception => e
      receipt.errors.add(:base, "Ocorreram erros ao salvar o registro!")
      receipt
    end
  end

end
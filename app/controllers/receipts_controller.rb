class ReceiptsController < ApplicationController
  before_action :authenticate_user

  def index
    @receipts = Receipt.order(data_recebimento: :desc).page(params[:page]).per(10)
  end

  def show
    @receipt = Receipt.find(params[:id])
  end

  def edit
    @receipt = Receipt.find(params[:id])
  end

  def destroy
    @receipt = Receipt.find(params[:id])
    @receipt.destroy
    flash[:success] = 'Recebimento removido com sucesso!'
    redirect_to receipts_url
  end

  def update
    @receipt = Receipt.find(params[:id])
    if @receipt.update_attributes(receipt_params)
      valor_total = ReceiptPayment.where(:receipt_id => @receipt.id).sum(&:valor_total_centavos)
      @receipt.update_attributes(:valor_total_centavos => valor_total)
      flash[:success] = 'Recebimento atualizado com sucesso!'
      redirect_to receipts_url
    else
      render 'edit'
    end
  end

  def new
    @receipt = Receipt.new
    @products = Product.all.order(:nome)
  end

  def create
    @receipt = Receipt.new(receipt_params)
    @receipt.user_id = current_user.id
    @receipt.tipo_recebimento = params[:tipo_recebimento]
    if @receipt.save
      ReceiptService.create(params, @receipt.id, receipt_params[:customer_id])
      valor_total = ReceiptPayment.where(:receipt_id => @receipt.id).sum(&:valor_total_centavos)
      @receipt.update_attributes(:valor_total_centavos => valor_total)
      flash[:success] = 'Recebimento criado com sucesso!'
      redirect_to receipts_url
    else
      render 'new'
    end
  end
  
  def get_companies
    if params[:customer_id].empty?
      @companies = []
    else
      @companies = Customer.find(params[:customer_id]).companies
    end
    respond_to :js
  end

  def get_infos
    if params[:customer_id].empty?
      @sales = []
      @receipts = []
    else
      @historic_sales = Customer.joins(:sales).select('sales.id')
        .where(['data_venda > ? AND customer_id = ?', 30.days.ago, params[:customer_id]])
        .order('sales.data_venda desc')
      @historic_receipts = Customer.joins(:receipts).select('receipts.id')
        .where(['data_recebimento > ? AND customer_id = ?', 30.days.ago, params[:customer_id]])
        .order('receipts.data_recebimento desc')

      week_sales = Customer.joins(:sales).select("user_id, 'venda' AS tipo, data_venda AS data, nome, valor_total_centavos AS total")
        .where(['data_venda > ? AND customer_id = ?', view_context.last_monday, params[:customer_id]])
        .order('sales.data_venda desc')
      week_receipts = Customer.joins(:receipts).select("user_id, 'recebimento' AS tipo, data_recebimento AS data, nome, valor_total_centavos AS total")
        .where(['data_recebimento > ? AND customer_id = ?', view_context.last_monday, params[:customer_id]])
        .order('receipts.data_recebimento desc')
      @week_infos = (week_sales + week_receipts).sort_by &:data

      total_sales = Customer.joins(:sales).where('customer_id = ?', params[:customer_id]).sum(:valor_total_centavos)
      total_receipts = Customer.joins(:receipts).where('customer_id = ?', params[:customer_id]).sum(:valor_total_centavos)
      @total = total_receipts + - total_sales
    end
    respond_to :js
  end

  private

  def receipt_params
    params.require(:receipt).permit(:customer_id, :data_recebimento, :valor_total, :observacao, :user_id, :tipo_recebimento,
      receipt_payments_attributes: [:id, :receipt_id, :payment_type_id, :valor_total, :data_pagamento, :nome_cheque, :numero_cheque, :_destroy])
  end

end

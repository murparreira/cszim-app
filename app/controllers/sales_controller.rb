class SalesController < ApplicationController
	before_action :authenticate_user

	def index
		@sales = Sale.order(data_venda: :desc).page(params[:page]).per(10)
	end

	def edit
    @sale = Sale.find(params[:id])
  end

  def show
    @sale = Sale.find(params[:id])
  end

  def destroy
    @sale = Sale.find(params[:id])
    @sale.destroy
    flash[:success] = 'Venda removida com sucesso!'
    redirect_to sales_url
  end

  def update
    @sale = Sale.find(params[:id])
    if @sale.update_attributes(sale_params)
      flash[:success] = 'Venda atualizada com sucesso!'
      redirect_to sales_url
    else
      render 'edit'
    end
  end

  def new
    @sale = Sale.new
    @products = Product.all.order(:nome)
  end

  def create
    @sale = Sale.new(sale_params)
    @sale.user_id = current_user.id
    if @sale.save
      SaleService.create(params, @sale.id)
      flash[:success] = 'Venda criada com sucesso!'
      redirect_to sales_url
    else
      @products = Product.all.order(:nome)
      render 'new'
    end
  end

  def get_companies
    puts params[:customer_id]
    if params[:customer_id].empty?
      @companies = []
    else
      @companies = Customer.find(params[:customer_id]).companies
    end
    respond_to :js
  end

  def sale_params
    params.require(:sale).permit(:data_venda, :valor_total, :observacao, :customer_id, :user_id, 
      product_sales: [:product_id, :quantidade, :_destroy],)
  end
end

class ProductsController < ApplicationController
	before_action :authenticate_user

	def index
		@products = Product.order(:nome)
	end

	def edit
    @product = Product.find(params[:id])
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    flash[:success] = 'Produto removido com sucesso!'
    redirect_to products_url
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      flash[:success] = 'Produto atualizado com sucesso!'
      redirect_to products_url
    else
      render 'edit'
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.ativo = true
    if @product.save
      flash[:success] = 'Produto criado com sucesso!'
      redirect_to products_url
    else
      render 'new'
    end
  end

  def toggle_status
    @product = Product.find params[:id]
    @product.toggle :ativo
    @product.save
    respond_to :js
  end

	private

  def product_params
    params.require(:product).permit(:nome, :valor)
  end
end

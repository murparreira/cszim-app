class SuppliersController < ApplicationController
	before_action :authenticate_user

	def index
		@suppliers = Supplier.order(:nome).page(params[:page]).per(5)
	end

	def edit
    @supplier = Supplier.find(params[:id])
  end

  def destroy
    @supplier = Supplier.find(params[:id])
    @supplier.destroy
    flash[:success] = 'Fornecedor removido com sucesso!'
    redirect_to suppliers_url
  end

  def update
    @supplier = Supplier.find(params[:id])
    if @supplier.update_attributes(supplier_params)
      flash[:success] = 'Fornecedor atualizado com sucesso!'
      redirect_to suppliers_url
    else
      render 'edit'
    end
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(supplier_params)
    @supplier.ativo = true
    if @supplier.save
      flash[:success] = 'Fornecedor criado com sucesso!'
      redirect_to suppliers_url
    else
      render 'new'
    end
  end

  def toggle_status
    @supplier = Supplier.find params[:id]
    @supplier.toggle :ativo
    @supplier.save
    respond_to :js
  end

	private

  def supplier_params
    params.require(:supplier).permit(:nome, :telefone, :endereco, :documento, :tipo_pessoa)
  end
end

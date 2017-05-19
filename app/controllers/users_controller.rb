class UsersController < ApplicationController
  before_action :authenticate_user

	def index
    @users = User.order(:nome)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    @user.destroy
    flash[:success] = 'Usuário removido com sucesso!'
    redirect_to users_url
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(user_params)
      flash[:success] = 'Usuário atualizado com sucesso!'
      redirect_to users_url
    else
      render 'edit'
    end
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    @user.ativo = true
    authorize @user
    if @user.save
      flash[:success] = 'Usuário criado com sucesso!'
      redirect_to users_url
    else
      render 'new'
    end
  end

  def toggle_status
    @user = User.find params[:id]
    @user.toggle :ativo
    @user.save
    respond_to :js
  end

  private

  def user_params
    params.require(:user).permit(:nome, :login, :steamid, :email, :password, :password_confirmation)
  end
end

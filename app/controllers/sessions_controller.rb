class SessionsController < ApplicationController
  layout 'login'

  before_action :authenticate_user, :except => [:new, :create, :destroy]

  def new
    if logged_in?
      redirect_to root_url
    end
  end

  def create
    user = User.find_by(login: params[:session][:login].downcase)
    if user && user.authenticate(params[:session][:password])      
      if user.ativo
        log_in user
        redirect_to root_url
      else
        flash.now[:error] = 'Usuário inativo. Favor consultar com o administrador da conta!'
        render 'new'
      end
    else
      flash.now[:error] = 'Combinação inválida de Usuário/Senha!'
      render 'new'
    end
  end

  def destroy
    flash[:success] = 'Você deslogou!'
    log_out if logged_in?
    redirect_to root_url
  end

end

class GamesController < ApplicationController
    before_action :authenticate_user

	def index
		@games = Game.order(id: :desc)
	end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(game_params)
      flash[:success] = 'Jogo atualizado com sucesso!'
      redirect_to games_url
    else
      render 'edit'
    end
  end

  def toggle_status
    @game = Game.find params[:id]
    @game.toggle :ativo
    @game.save
    Game.where.not(id: params[:id]).update_all(ativo: false)
    respond_to :js
  end

	private

  def game_params
    params.require(:game).permit(:nome, :sigla, :login)
  end
end

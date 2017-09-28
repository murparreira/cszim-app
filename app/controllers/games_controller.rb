class GamesController < ApplicationController
    before_action :authenticate_user

	def index
		@games = Game.order(id: :desc)
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
    params.require(:game).permit(:nome)
  end
end

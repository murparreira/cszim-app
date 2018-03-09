class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  include SessionsHelper

  rescue_from ActiveRecord::RecordNotFound do
    flash[:warning] = 'Recurso não encontrado.'
    redirect_back_or root_path
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    flash[:alert] = "Você não está autorizado a realizar essa ação!"
    redirect_back_or root_path
  end

  def redirect_back_or(path)
    redirect_to request.referer || path
  end

  def clean_select_multiple_params hash = params
    hash.each do |k, v|
      case v
      when Array then v.reject!(&:blank?)
      when Hash then clean_select_multiple_params(v)
      end
    end
  end

  def current_game
    Game.find_by(ativo: true)
  end

  def current_season
    Season.last
  end

  def current_configuration
    ServerConfiguration.find_by(ativo: true)
  end

end

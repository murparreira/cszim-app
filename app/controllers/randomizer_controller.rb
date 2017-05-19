class RandomizerController < ApplicationController
  layout "application_reduzido"

  before_action :authenticate_user

  def index
    if session[:maps].nil?
      init_maps
    end
    if params[:random]
      p session[:maps]
      p session[:maps].size
      session[:chosen_map] = session[:maps].sample
      p session[:chosen_map]
      session[:maps] = session[:maps] - [session[:chosen_map]]
      p session[:maps]
      p session[:maps].size
      session[:chosen_maps] << session[:chosen_map]
      p session[:chosen_maps]
      p session[:chosen_maps].size
    end
    if params[:reset]
      session[:chosen_map] = nil
      session[:chosen_maps] = []
      init_maps
    end
  end

  def init_maps
    session[:maps] = Map.where(ativo: true).order('random()').pluck(:id)
  end

end

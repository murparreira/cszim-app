class RandomizerController < ApplicationController

  before_action :authenticate_user

  def index
    if session[:maps].nil?
      init_maps
    end
    if params[:random] && session[:maps].any?
      session[:chosen_map] = session[:maps].sample
      session[:maps] = session[:maps] - [session[:chosen_map]]
      session[:chosen_maps] = [] if session[:chosen_maps].nil?
      session[:chosen_maps] << session[:chosen_map]
    end
    if params[:reset]
      session[:chosen_map] = nil
      session[:chosen_maps] = []
      init_maps
    end
  end

  def init_maps
    session[:maps] = Map.ativos.order('random()').pluck(:id)
  end

end

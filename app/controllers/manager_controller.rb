require 'net/ssh'

class ManagerController < ApplicationController
  before_action :authenticate_user

  def index
  end

  def open_map
    map = Map.find(RandomMap.last.map_id)
    Net::SSH.start(current_configuration.server_name_or_ip, current_configuration.server_user, password: current_configuration.server_password, port: current_configuration.server_port) do| ssh |
      ssh.exec! "tmux send-keys 'changelevel #{map.sigla}' Enter"
    end
    flash[:success] = "Mapa mudou para #{map.nome} - #{map.sigla}!"
    redirect_to manager_url
  rescue Errno::ECONNREFUSED
    flash[:warning] = "Conexão recusada com o servidor!"
    redirect_to manager_url
  end

  def select
    RandomMap.create(map_id: params[:map_id])
    redirect_to manager_url
  end

  def raffle
    chosen_map = (Map.where(game_id: current_game.id).ativos.pluck(:id) - RandomMap.pluck(:map_id)).sample
    RandomMap.create(map_id: chosen_map) if chosen_map
    redirect_to manager_url
  end

  def reset
    RandomMap.destroy_all
    redirect_to manager_url
  end

  def start
    torneio_dia = Tournament.find_by(nome: "Torneio #{Date.today.to_s(:human)}")
    random_map = RandomMap.last.map
    if torneio_dia.nil?
      torneio_dia = Tournament.create(nome: "Torneio #{Date.today.to_s(:human)}", season_id: current_season.id)
      flash[:success] = "Torneio #{Date.today.to_s(:human)} e mapa iniciado com sucesso!"
    else
      flash[:success] = "Mapa iniciado com sucesso!"
    end
    Net::SSH.start(current_configuration.server_name_or_ip, current_configuration.server_user, password: current_configuration.server_password, port: current_configuration.server_port) do| ssh |
      ssh.exec! "tmux send-keys 'tv_stoprecord' Enter"
      ssh.exec! "tmux send-keys 'sm plugins unload kento_rankme' Enter"
      ssh.exec! "tmux send-keys 'sm plugins unload rankme' Enter"
    end
    RankmeMysqlCsgo.delete_all
    Net::SSH.start(current_configuration.server_name_or_ip, current_configuration.server_user, password: current_configuration.server_password, port: current_configuration.server_port) do| ssh |
      ssh.exec! "tmux send-keys 'mp_warmup_end' Enter"
      ssh.exec! "tmux send-keys 'mp_restartgame 2' Enter"
      ssh.exec! "tmux send-keys 'sm plugins load rankme' Enter"
      ssh.exec! "tmux send-keys 'sm plugins load kento_rankme' Enter"
      ssh.exec! "tmux send-keys 'tv_enable 1' Enter"
      nome_replay = Time.now.day.to_s.rjust(2, "0") + '_' + Time.now.month.to_s + '_' + Time.now.year.to_s + '_' + random_map.sigla
      ssh.exec! "tmux send-keys 'tv_record #{nome_replay}' Enter"
      Demo.create(
        nome: nome_replay,
        map_id: random_map.id
      )
    end
    redirect_to randomizer_url
  rescue Errno::ECONNREFUSED
    flash[:warning] = "Conexão recusada com o servidor!"
    redirect_to randomizer_url
  end

  def finish
    demo = Demo.last
    # Net::SSH.start(current_configuration.server_name_or_ip, current_configuration.server_user, password: current_configuration.server_password, port: current_configuration.server_port) do| ssh |
    #   ssh.exec! "tmux send-keys 'tv_stoprecord' Enter"
    # end
    # ParserJob.set(queue: :default, wait: 5.seconds, priority: 10).perform_later(demo.nome)
    ParserJob.set(queue: :default, wait: 5.seconds, priority: 10).perform_later(demo.id)
    flash[:success] = "Mapa finalizado com sucesso!"
    redirect_to manager_url
  rescue Errno::ECONNREFUSED
    flash[:warning] = "Conexão recusada com o servidor!"
    redirect_to manager_url
  end

end

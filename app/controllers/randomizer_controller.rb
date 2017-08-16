require 'net/ssh'

class RandomizerController < ApplicationController

  def index
  end

  def open_map
    map = Map.find(RandomMap.last.map_id)
    Net::SSH.start('201.25.106.82', 'cssserver', :password => 's3nh4123') do| ssh |
      ssh.exec! "tmux send-keys 'changelevel #{map.sigla}' Enter"
    end
    flash[:success] = "Mapa mudou para #{map.nome} - #{map.sigla}!"
    redirect_to randomizer_url
  end

  def raffle
    chosen_map = (Map.ativos.pluck(:id) - RandomMap.pluck(:map_id)).sample
    RandomMap.create(map_id: chosen_map)
    redirect_to randomizer_url
  end

  def reset
    RandomMap.destroy_all
    redirect_to randomizer_url
  end

  def start
    torneio_dia = Tournament.find_by(nome: "Torneio #{Date.today.to_s(:human)}")
    if torneio_dia.nil?
      torneio_dia = Tournament.create(nome: "Torneio #{Date.today.to_s(:human)}")
      flash[:success] = "Torneio #{Date.today.to_s(:human)} e mapa iniciado com sucesso!"
    else
      flash[:success] = "Mapa iniciado com sucesso!"
    end
    Net::SSH.start('201.25.106.82', 'cssserver', :password => 's3nh4123') do| ssh |
      ssh.exec! "tmux send-keys 'sm plugins unload rankme' Enter"
    end
    RankmeMysql.delete_all
    Net::SSH.start('201.25.106.82', 'cssserver', :password => 's3nh4123') do| ssh |
      ssh.exec! "tmux send-keys 'mp_restartgame 2' Enter"
      ssh.exec! "tmux send-keys 'sm plugins load rankme' Enter"
    end
    redirect_to randomizer_url
  end

  def finish
    # Consulta o torneio do dia
    torneio_dia = Tournament.find_by(nome: "Torneio #{Date.today.to_s(:human)}")
    # Verificar se houve algum vencedor
    vencedor_ct = RankmeMysql.find_by(ct_win: 7)
    vencedor_tr = RankmeMysql.find_by(tr_win: 7)
    # Se existir vencedor da partida
    if vencedor_ct || vencedor_tr
      # Cria o round com os dados de torneio e mapa
      chosen_map = RandomMap.last
      round = Round.create(tournament_id: torneio_dia.id, map_id: chosen_map.map_id)
      # Pega todos os códigos da steam dos jogadores do time CT
      jogadores_time_ct = RankmeMysql.where("rounds_ct > 0").pluck(:steam).sort
      # Pega todos os ids de usuário dos jogadores do time CT
      ids_jogadores_time_ct = User.where(steam: jogadores_time_ct).pluck(:id).sort
      # Verificar quais os times existentes que esses jogadores participam
      ids_times_ja_criados = Team.joins(:players).where("players.user_id IN (?)", ids_jogadores_time_ct).pluck(:id).uniq.sort
      # Para cada time, consultar os jogadores do mesmo e comparar o resultado em forma de array com os ids do time atual
      salvar_novo_time = true
      time_ct = nil
      ids_times_ja_criados.each do |team_id|
        jogadores_desse_time = Team.find(team_id).users.pluck(:id).sort
        if jogadores_desse_time == ids_jogadores_time_ct
          time_ct = Team.find(team_id)
          salvar_novo_time = false
          break
        end
      end
      if salvar_novo_time
        time_ct = Team.create(nome: "Time #{helpers.criar_nome_time(ids_jogadores_time_ct)}")
        Participant.create(team_id: time_ct.id, tournament_id: torneio_dia.id)
      end
      jogadores_time_ct.each do |steam_jogador|
        # Identifica o jogador na tabela users pelo steam
        user = User.find_by(steam: steam_jogador)
        # Pega todos os dados desse jogador no mysql removendo o id
        dados_mysql = RankmeMysql.find_by(:steam => user.steam)
        dados_tratados = dados_mysql.as_json.select {|k,v| k != 'id'}
        # Coloca o resto das informações no hash para salvar
        dados_tratados[:user_id] = user.id
        dados_tratados[:map_id] = chosen_map.map_id
        dados_tratados[:tournament_id] = torneio_dia.id
        dados_tratados[:round_id] = round.id
        dados_tratados[:team_id] = time_ct.id
        # Salva todos os dados do jogador que veio do mysql na tabela rankmes do sistema
        Rankme.create(dados_tratados)
        # Insere o jogador no time CT
        Player.where(team_id: time_ct.id, user_id: user.id).first_or_create
      end
      # Pega todos os códigos da steam dos jogadores do time TR
      jogadores_time_tr = RankmeMysql.where("rounds_tr > 0").pluck(:steam)
      # Pega todos os ids de usuário dos jogadores do time TR
      ids_jogadores_time_tr = User.where(steam: jogadores_time_tr).pluck(:id).sort
      # Verificar quais os times existentes que esses jogadores participam
      ids_times_ja_criados = Team.joins(:players).where("players.user_id IN (?)", ids_jogadores_time_tr).pluck(:id).uniq.sort
      # Para cada time, consultar os jogadores do mesmo e comparar o resultado em forma de array com os ids do time atual
      salvar_novo_time = true
      time_tr = nil
      ids_times_ja_criados.each do |team_id|
        jogadores_desse_time = Team.find(team_id).users.pluck(:id).sort
        if jogadores_desse_time == ids_jogadores_time_tr
          time_tr = Team.find(team_id)
          salvar_novo_time = false
          break
        end
      end
      if salvar_novo_time
        time_tr = Team.create(nome: "Time #{helpers.criar_nome_time(ids_jogadores_time_tr)}")
        Participant.create(team_id: time_tr.id, tournament_id: torneio_dia.id)
      end
      jogadores_time_tr.each do |steam_jogador|
        # Identifica o jogador na tabela users pelo steam
        user = User.find_by(steam: steam_jogador)
        # Pega todos os dados desse jogador no mysql removendo o id
        dados_mysql = RankmeMysql.find_by(:steam => user.steam)
        dados_tratados = dados_mysql.as_json.select {|k,v| k != 'id'}
        # Coloca o resto das informações no hash para salvar
        dados_tratados[:user_id] = user.id
        dados_tratados[:map_id] = chosen_map.map_id
        dados_tratados[:tournament_id] = torneio_dia.id
        dados_tratados[:round_id] = round.id
        dados_tratados[:team_id] = time_tr.id
        # Salva todos os dados do jogador que veio do mysql na tabela rankmes do sistema
        Rankme.create(dados_tratados)
        # Insere o jogador no time TR
        Player.where(team_id: time_tr.id, user_id: user.id).first_or_create
      end
      # Se o vencedor foi o time CT
      if vencedor_ct
        Winner.create(team_id: time_ct.id, round_id: round.id, placar: 7, lado: 'ct')
        # Pega o número maior de vitorias dos TR
        vitorias_tr = RankmeMysql.where("tr_win > 0").pluck(:tr_win).max
        Loser.create(team_id: time_tr.id, round_id: round.id, placar: vitorias_tr, lado: 't')
      end
      # Se o vencedor foi o time TR
      if vencedor_tr
        Winner.create(team_id: time_tr.id, round_id: round.id, placar: 7, lado: 't')
        # Pega o número maior de vitorias dos CT
        vitorias_ct = RankmeMysql.where("ct_win > 0").pluck(:ct_win).max
        Loser.create(team_id: time_ct.id, round_id: round.id, placar: vitorias_ct, lado: 'ct')
      end      
      flash[:success] = "Mapa finalizado com sucesso!"
    else
      # Se não existir vencedor da partida, só retorna uma mensagem
      flash[:warning] = "Mapa não teve um vencedor. Não foi gravado os dados!"
    end
    redirect_to randomizer_url
  end

end

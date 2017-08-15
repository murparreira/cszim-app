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
    columns = RankmeMysql.columns.map(&:name)
    columns_to_update = columns - ["id", "steam", "name", "lastip"]
    columns_with_zero = columns_to_update.map { |c| [c, 0] }.to_h
    RankmeMysql.all.update columns_with_zero
    redirect_to randomizer_url
  end

  def start
    @torneio_dia = Tournament.find_by(nome: "Torneio #{Date.today.to_s(:human)}")
    if @torneio_dia.nil?
      @torneio_dia = Tournament.create(nome: "Torneio #{Date.today.to_s(:human)}")
      @ct_team = Team.create(nome: "Time 1 CT #{Date.today.to_s(:human)}")
      @tr_team = Team.create(nome: "Time 2 TR #{Date.today.to_s(:human)}")
      Participant.create(team_id: @ct_team.id, tournament_id: @torneio_dia.id)
      Participant.create(team_id: @tr_team.id, tournament_id: @torneio_dia.id)
      flash[:success] = "Torneio #{Date.today.to_s(:human)} e mapa iniciado com sucesso!"
    else
      flash[:success] = "Mapa iniciado com sucesso!"
    end
    columns = RankmeMysql.columns.map(&:name)
    columns_to_update = columns - ["id", "steam", "name", "lastip"]
    columns_with_zero = columns_to_update.map { |c| [c, 0] }.to_h
    RankmeMysql.all.update columns_with_zero
    Net::SSH.start('201.25.106.82', 'cssserver', :password => 's3nh4123') do| ssh |
      ssh.exec! "tmux send-keys 'mp_restartgame 2' Enter"
    end
    redirect_to randomizer_url
  end

  def finish
    # Consulta o torneio do dia
    torneio_dia = Tournament.find_by(nome: "Torneio #{Date.today.to_s(:human)}")
    # Consulta os times do torneio do dia
    time_ct = Team.find_by(nome: "Time 1 CT #{Date.today.to_s(:human)}")
    time_tr = Team.find_by(nome: "Time 2 TR #{Date.today.to_s(:human)}")
    # Verificar se houve algum vencedor
    vencedor_ct = RankmeMysql.find_by(ct_win: 7)
    vencedor_tr = RankmeMysql.find_by(tr_win: 7)
    # Se existir vencedor da partida
    if vencedor_ct || vencedor_tr
      # Cria o round com os dados de torneio e mapa
      chosen_map = RandomMap.last
      round = Round.create(tournament_id: torneio_dia.id, map_id: chosen_map.map_id)
      # Pega todos os jogadores do time CT
      jogadores_time_ct = RankmeMysql.where("rounds_ct > 0").pluck(:steam)
      jogadores_time_ct.each do |steam_jogador|
        # Identifica o jogador na tabela users pelo steam
        user = User.find_by(steam: steam_jogador)
        # Pega todos os dados desse jogador no mysql removendo o id
        dados_mysql = RankmeMysql.find_by(:steam => user.steam)
        dados_tratados = dados_mysql.as_json.select {|k,v| k != 'id'}
        # Coloca o resto das informações no hash para salvar
        dados_tratados[:user_id] = user.id
        dados_tratados[:map_id] = chosen_map.id
        dados_tratados[:tournament_id] = torneio_dia.id
        dados_tratados[:round_id] = round.id
        dados_tratados[:team_id] = time_ct.id
        # Salva todos os dados do jogador que veio do mysql na tabela rankmes do sistema
        Rankme.create(dados_tratados)
        # Insere o jogador no time CT
        Player.where(team_id: time_ct.id, user_id: user.id).first_or_create
      end
      # Pega todos os jogadores do time TR
      jogadores_time_tr = RankmeMysql.where("rounds_tr > 0").pluck(:steam)
      jogadores_time_tr.each do |steam_jogador|
        # Identifica o jogador na tabela users pelo steam
        user = User.find_by(steam: steam_jogador)
        # Pega todos os dados desse jogador no mysql removendo o id
        dados_mysql = RankmeMysql.find_by(:steam => user.steam)
        dados_tratados = dados_mysql.as_json.select {|k,v| k != 'id'}
        # Coloca o resto das informações no hash para salvar
        dados_tratados[:user_id] = user.id
        dados_tratados[:map_id] = chosen_map.id
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
      # Zera todas as estatísticas de todos os jogadores
      columns = RankmeMysql.columns.map(&:name)
      columns_to_update = columns - ["id", "steam", "name", "lastip"]
      columns_with_zero = columns_to_update.map { |c| [c, 0] }.to_h
      RankmeMysql.all.update columns_with_zero
      flash[:success] = "Mapa finalizado com sucesso!"
    else
      # Se não existir vencedor da partida, só retorna uma mensagem
      flash[:warning] = "Mapa não teve um vencedor. Não foi gravado os dados!"
    end
    redirect_to randomizer_url
  end

end

require 'uri'
require 'net/http'

class ParserJob < ApplicationJob

  def perform(demo_id)
    demo = Demo.find(demo_id)
    uri = URI(ENV['PARSE_URL'])
    res = Net::HTTP.post_form(uri, 'demo_file' => "#{demo.nome}.dem")
    if res.is_a?(Net::HTTPSuccess)
      json_response = JSON.parse(res.body)
      demo.update(processada: true)
      json_response['players'].each do |steam, data|
        user = User.find_by(steam: steam)
        if user
          player_statistic = PlayerStatistic.create(
            demo_id: demo.id,
            user_id: user.id,
            accuracy: data['accuracy'],
            adr: data['adr'],
            assists: data['assists'],
            attempts1v1: data['attempts1v1'],
            attempts1v2: data['attempts1v2'],
            attempts1v3: data['attempts1v3'],
            attempts1v4: data['attempts1v4'],
            attempts1v5: data['attempts1v5'],
            blindTime: data['blindTime'],
            deaths: data['deaths'],
            defuses: data['defuses'],
            enemiesFlashed: data['enemiesFlashed'],
            fireThrown: data['fireThrown'],
            firstDeaths: data['firstDeaths'],
            firstKills: data['firstKills'],
            flashAssists: data['flashAssists'],
            flashesThrown: data['flashesThrown'],
            heThrown: data['heThrown'],
            hs: data['hs'],
            hsPercent: data['hsPercent'],
            kast: data['kast'],
            kdr: data['kdr'],
            kills: data['kills'],
            kills0: data['kills0'],
            kills1: data['kills1'],
            kills2: data['kills2'],
            kills3: data['kills3'],
            kills4: data['kills4'],
            kills5: data['kills5'],
            plants: data['plants'],
            rating: data['rating'],
            shotsHit: data['shotsHit'],
            smokesThrown: data['smokesThrown'],
            success1v1: data['success1v1'],
            success1v2: data['success1v2'],
            success1v3: data['success1v3'],
            success1v4: data['success1v4'],
            success1v5: data['success1v5'],
            suicides: data['suicides'],
            teamKills: data['teamKills'],
            teammatesFlashed: data['teammatesFlashed'],
            totalDamageGiven: data['totalDamageGiven'],
            totalDamageTaken: data['totalDamageTaken'],
            totalRounds: data['totalRounds'],
            totalShots: data['totalShots'],
            totalTeamDamageGiven: data['totalTeamDamageGiven'],
            tradeKills: data['tradeKills'],
            tradedDeaths: data['tradedDeaths'],
            utilityDamage: data['utilityDamage']
          )
          data['player_kills'].each do |player_kill|
            PlayerKill.create(
              player_statistic_id: player_statistic.id,
              attackerBlinded: player_kill['attackerBlinded'],
              attackerSide: player_kill['attackerSide'],
              victimSteamID: player_kill['victimSteamID'],
              distance: player_kill['distance'],
              isFirstKill: player_kill['isFirstKill'],
              isWallbang: player_kill['isWallbang'],
              noScope: player_kill['noScope'],
              thruSmoke: player_kill['thruSmoke'],
              victimBlinded: player_kill['victimBlinded'],
              weapon: player_kill['weapon'],
              weaponClass: player_kill['weaponClass']
            )
          end
        end
      end
      json_response['rounds'].each do |round|
        demo_round = DemoRound.create(
          demo_id: demo.id,
          roundNum: round['roundNum'],
          winningSide: round['winningSide']
        )
        round['kills'].each do |kill|
          DemoRoundKill.create(
            demo_round_id: demo_round.id,
            tick: kill['tick'],
            attackerSteamID: kill['attackerSteamID'],
            attackerSide: kill['attackerSide'],
            assisterSteamID: kill['assisterSteamID'],
            assisterSide: kill['assisterSide'],
            victimSteamID: kill['victimSteamID'],
            victimSide: kill['victimSide'],
            distance: kill['distance'],
            isWallbang: kill['isWallbang'],
            noScope: kill['noScope'],
            thruSmoke: kill['thruSmoke'],
            attackerBlinded: kill['attackerBlinded'],
            victimBlinded: kill['victimBlinded'],
            weapon: kill['weapon'],
            weaponClass: kill['weaponClass']
          )
        end
      end
      last_round = json_response['rounds'].last
      end_ct_score = last_round['endCTScore']
      end_t_score = last_round['endTScore']
      demo.update(
        score: "#{end_ct_score}:#{end_t_score}"
      )
      end_ct_team_name = last_round['ctSide']['players'].to_h do |player|
        user = User.find_by(steam: player['steamID'])
        [user, player['steamID'].to_s.last(9)]
      end
      end_t_team_name = last_round['tSide']['players'].to_h do |player|
        user = User.find_by(steam: player['steamID'])
        [user, player['steamID'].to_s.last(9)]
      end
      end_ct_team = Team.safe_find_or_create_by(nome: end_ct_team_name.values.join)
      end_ct_team.users << end_ct_team_name.keys
      
      end_t_team = Team.safe_find_or_create_by(nome: end_t_team_name.values.join)
      end_t_team.users << end_t_team_name.keys

      if end_ct_score > end_t_score
        end_ct_team.vitorias += 1
        end_ct_team.save
        end_t_team.derrotas += 1
        end_t_team.save
        demo.update(
          time_vencedor_id: end_ct_team.id,
          time_perdedor_id: end_t_team.id
        )
      elsif end_t_score > end_ct_score
        end_t_team.vitorias += 1
        end_t_team.save
        end_ct_team.derrotas += 1
        end_ct_team.save
        demo.update(
          time_vencedor_id: end_t_team.id,
          time_perdedor_id: end_ct_team.id
        )
      else
        end_ct_team.empates += 1
        end_ct_team.save
        end_t_team.empates += 1
        end_t_team.save
      end
    end
  end

end
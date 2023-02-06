require 'uri'
require 'net/http'

class ParserJob < ApplicationJob

  def perform(demo_id)
    demo = Demo.find(demo_id)
    uri = URI('http://web:5000/parse')
    res = Net::HTTP.post_form(uri, 'demo_file' => "#{demo.nome}.dem")
    if res.is_a?(Net::HTTPSuccess)
      json_response = JSON.parse(res.body)
      demo.update(processada: true)
      json_response.each do |steam, data|
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
          data['player_kills'].each do |inner_data|
            PlayerKill.create(
              player_statistic_id: player_statistic.id,
              attackerBlinded: inner_data['attackerBlinded'],
              attackerSide: inner_data['attackerSide'],
              victimSteamID: inner_data['victimSteamID'],
              distance: inner_data['distance'],
              isFirstKill: inner_data['isFirstKill'],
              isWallbang: inner_data['isWallbang'],
              noScope: inner_data['noScope'],
              thruSmoke: inner_data['thruSmoke'],
              victimBlinded: inner_data['victimBlinded'],
              weapon: inner_data['weapon'],
              weaponClass: inner_data['weaponClass']
            )
          end
        end
      end
    end
  end

end
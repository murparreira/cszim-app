# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ActiveRecord::Base.transaction do

	murillo = User.create(nome: "Murillo Parreira", email: "murparreira@gmail.com", login: "admin", password: "admin", admin: true, ativo: true, steamid: "http://steamcommunity.com/id/murifox")
	ricardo = User.create(nome: "Ricardo Pulice", email: "ricardopulice@gmail.com", login: "rpulice", password: "rpulice", ativo: true, steamid: "")

	edilson = User.create(nome: "Edilson Borges", email: "edilsonfb@gmail.com", login: "edilsonfb", password: "edilsonfb", ativo: true, steamid: "http://steamcommunity.com/id/edilson")
	danilo = User.create(nome: "Danilo Lopes", email: "danilolopesdemoraes@gmail.com", login: "bileite", password: "bileite", ativo: true, steamid: "http://steamcommunity.com/profiles/76561198044844552")
	wemerson = User.create(nome: "Wemerson Souto", email: "wpsouto@gmail.com", login: "amigao", password: "amigao", ativo: true, steamid: "http://steamcommunity.com/id/wpsouto")
	naiara = User.create(nome: "Naiara Fatima", email: "nnayara.pedrozo@gmail.com", login: "naiara", password: "naiara", ativo: true, steamid: "http://steamcommunity.com/profiles/76561198158451974")

	de_desertcityfixed = Map.create(nome: "Desertim", sigla: "de_desertcityfixed")
	de_abbotabad = Map.create(nome: "Abbotabad", sigla: "de_abbotabad")
	de_roma_aimstyle = Map.create(nome: "Roma", sigla: "de_roma_aimstyle")
	de_cpl_strike = Map.create(nome: "Mirage", sigla: "de_cpl_strike")
	cs_hacienda = Map.create(nome: "Mansão dos Refém", sigla: "cs_hacienda")
	de_villa = Map.create(nome: "Villa", sigla: "de_villa")
	de_asia = Map.create(nome: "Asia", sigla: "de_asia")
	cs_compound = Map.create(nome: "Compound", sigla: "cs_compound")
	de_cpl_mill = Map.create(nome: "Tuscan", sigla: "de_cpl_mill")
	de_tides = Map.create(nome: "Tides", sigla: "de_tides")
	de_aztec = Map.create(nome: "Aztec", sigla: "de_aztec")
	de_outlaws = Map.create(nome: "Velho Oeste", sigla: "de_outlaws")
	de_winter_village = Map.create(nome: "Vila de Inverno", sigla: "de_winter_village")
	de_cevo_diesel = Map.create(nome: "Diesel", sigla: "de_cevo_diesel")
	de_slummi = Map.create(nome: "Slummi", sigla: "de_slummi")
	de_yacer_v3 = Map.create(nome: "Deserto da Feira", sigla: "de_yacer_v3")
	de_bit_gallery = Map.create(nome: "Galeria", sigla: "de_bit_gallery")

	###### Torneio de Março ######
	torneio_marco = Tournament.create(nome: "Torneio de Março")

	time_um_marco = Team.create(nome: "DNS")
	time_um_marco.users << murillo
	time_um_marco.users << danilo
	time_um_marco.users << wemerson

	time_dois_marco = Team.create(nome: "RUIM")
	time_dois_marco.users << edilson
	time_dois_marco.users << ricardo
	time_dois_marco.users << naiara

	torneio_marco.teams << time_um_marco
	torneio_marco.teams << time_dois_marco

	pontos = 0
	1.upto(3) do |i|
		if pontos < 6
			pontos_round = 3
			pontos += 3
		else
			pontos_round = 4
			pontos += 4
		end
		round = Round.create(tournament_id: torneio_marco.id, pontos: pontos_round)
		Winner.create(round_id: round.id, team_id: time_dois_marco.id)
		Loser.create(round_id: round.id, team_id: time_um_marco.id)
		torneio_marco.rounds << round
	end

	pontos = 0
	1.upto(14) do |i|
		if pontos < 36
			pontos_round = 3
			pontos += 3
		else
			pontos_round = 4
			pontos += 4
		end
		round = Round.create(tournament_id: torneio_marco.id, pontos: pontos_round)
		Winner.create(round_id: round.id, team_id: time_um_marco.id)
		Loser.create(round_id: round.id, team_id: time_dois_marco.id)
		torneio_marco.rounds << round
	end
	###############################

	###### Torneio de Abril ######
	torneio_abril = Tournament.create(nome: "Torneio de Abril")

	time_um_abril = Team.create(nome: "Igreja Católica")
	time_um_abril.users << murillo
	time_um_abril.users << edilson

	time_dois_abril = Team.create(nome: "Candomblé")
	time_dois_abril.users << danilo
	time_dois_abril.users << ricardo
	time_dois_abril.users << naiara
	time_dois_abril.users << wemerson

	torneio_abril.teams << time_um_abril
	torneio_abril.teams << time_dois_abril

	1.upto(11) do |i|
		round = Round.create(tournament_id: torneio_abril.id, pontos: 3)
		Winner.create(round_id: round.id, team_id: time_dois_abril.id)
		Loser.create(round_id: round.id, team_id: time_um_abril.id)
		torneio_abril.rounds << round
	end

	1.upto(15) do |i|
		round = Round.create(tournament_id: torneio_abril.id, pontos: 3)
		Winner.create(round_id: round.id, team_id: time_um_abril.id)
		Loser.create(round_id: round.id, team_id: time_dois_abril.id)
		torneio_abril.rounds << round
	end
	###############################

	###### Torneio de Maio ######
	torneio_maio = Tournament.create(nome: "Torneio de Maio")

	time_um = Team.create(nome: "Joalheria")
	time_um.users << murillo
	time_um.users << ricardo

	time_dois = Team.create(nome: "Ladrões")
	time_dois.users << edilson
	time_dois.users << danilo
	time_dois.users << wemerson
	time_dois.users << naiara

	torneio_maio.teams << time_um
	torneio_maio.teams << time_dois

	1.upto(24) do |i|
		round = Round.create(tournament_id: torneio_maio.id, pontos: 3)
		Winner.create(round_id: round.id, team_id: time_dois.id)
		Loser.create(round_id: round.id, team_id: time_um.id)
		torneio_maio.rounds << round
	end

	1.upto(12) do |i|
		round = Round.create(tournament_id: torneio_maio.id, pontos: 3)
		Winner.create(round_id: round.id, team_id: time_um.id)
		Loser.create(round_id: round.id, team_id: time_dois.id)
		torneio_maio.rounds << round
	end

	round_um = Round.create(tournament_id: torneio_maio.id, map_id: de_cevo_diesel.id, ct_team_id: time_dois.id, t_team_id: time_um.id)
	winner_round_um = Winner.create(round_id: round_um.id, team_id: time_um.id, placar: 7, lado: "t")
	loser_round_um = Loser.create(round_id: round_um.id, team_id: time_dois.id, placar: 4, lado: "ct")
	Statistic.create(round_id: round_um.id, team_id: time_um.id, user_id: murillo.id, kills: 27, deaths: 5)
	Statistic.create(round_id: round_um.id, team_id: time_um.id, user_id: ricardo.id, kills: 12, deaths: 8)
	Statistic.create(round_id: round_um.id, team_id: time_dois.id, user_id: edilson.id, kills: 11, deaths: 8)
	Statistic.create(round_id: round_um.id, team_id: time_dois.id, user_id: naiara.id, kills: 7, deaths: 9)
	Statistic.create(round_id: round_um.id, team_id: time_dois.id, user_id: danilo.id, kills: 3, deaths: 9)
	Statistic.create(round_id: round_um.id, team_id: time_dois.id, user_id: wemerson.id, kills: 1, deaths: 10)

	torneio_maio.rounds << round_um

	round_dois = Round.create(tournament_id: torneio_maio.id, map_id: de_desertcityfixed.id, ct_team_id: time_dois.id, t_team_id: time_um.id)
	winner_round_dois = Winner.create(round_id: round_dois.id, team_id: time_dois.id, placar: 7, lado: "ct")
	loser_round_dois = Loser.create(round_id: round_dois.id, team_id: time_um.id, placar: 1, lado: "t")
	Statistic.create(round_id: round_dois.id, team_id: time_um.id, user_id: murillo.id, kills: 9, deaths: 8)
	Statistic.create(round_id: round_dois.id, team_id: time_um.id, user_id: ricardo.id, kills: 3, deaths:7)
	Statistic.create(round_id: round_dois.id, team_id: time_dois.id, user_id: naiara.id, kills: 7, deaths: 2)
	Statistic.create(round_id: round_dois.id, team_id: time_dois.id, user_id: edilson.id, kills: 7, deaths: 3)
	Statistic.create(round_id: round_dois.id, team_id: time_dois.id, user_id: danilo.id, kills: 3, deaths: 3)
	Statistic.create(round_id: round_dois.id, team_id: time_dois.id, user_id: wemerson.id, kills: 1, deaths: 4)

	torneio_maio.rounds << round_dois

	round_tres = Round.create(tournament_id: torneio_maio.id, map_id: de_slummi.id, ct_team_id: time_dois.id, t_team_id: time_um.id)
	winner_round_tres = Winner.create(round_id: round_tres.id, team_id: time_dois.id, placar: 7, lado: "ct")
	loser_round_tres = Loser.create(round_id: round_tres.id, team_id: time_um.id, placar: 4, lado: "t")
	Statistic.create(round_id: round_tres.id, team_id: time_um.id, user_id: murillo.id, kills: 21, deaths: 7)
	Statistic.create(round_id: round_tres.id, team_id: time_um.id, user_id: ricardo.id, kills: 5, deaths: 10)
	Statistic.create(round_id: round_tres.id, team_id: time_dois.id, user_id: edilson.id, kills: 8, deaths: 5)
	Statistic.create(round_id: round_tres.id, team_id: time_dois.id, user_id: danilo.id, kills: 6, deaths: 7)
	Statistic.create(round_id: round_tres.id, team_id: time_dois.id, user_id: naiara.id, kills: 4, deaths: 6)
	Statistic.create(round_id: round_tres.id, team_id: time_dois.id, user_id: wemerson.id, kills: 2, deaths: 5)

	torneio_maio.rounds << round_tres

	round_quatro = Round.create(tournament_id: torneio_maio.id, map_id: de_yacer_v3.id, ct_team_id: time_um.id, t_team_id: time_dois.id)
	winner_round_quatro = Winner.create(round_id: round_quatro.id, team_id: time_dois.id, placar: 7, lado: "t")
	loser_round_quatro = Loser.create(round_id: round_quatro.id, team_id: time_um.id, placar: 2, lado: "ct")
	Statistic.create(round_id: round_quatro.id, team_id: time_um.id, user_id: murillo.id, kills: 22, deaths: 8)
	Statistic.create(round_id: round_quatro.id, team_id: time_um.id, user_id: ricardo.id, kills: 6, deaths: 8)
	Statistic.create(round_id: round_quatro.id, team_id: time_dois.id, user_id: edilson.id, kills: 6, deaths: 5)
	Statistic.create(round_id: round_quatro.id, team_id: time_dois.id, user_id: naiara.id, kills: 5, deaths: 6)
	Statistic.create(round_id: round_quatro.id, team_id: time_dois.id, user_id: wemerson.id, kills: 3, deaths: 5)
	Statistic.create(round_id: round_quatro.id, team_id: time_dois.id, user_id: danilo.id, kills: 2, deaths: 6)

	torneio_maio.rounds << round_quatro

	round_cinco = Round.create(tournament_id: torneio_maio.id, map_id: de_abbotabad.id, ct_team_id: time_dois.id, t_team_id: time_um.id)
	winner_round_cinco = Winner.create(round_id: round_cinco.id, team_id: time_dois.id, placar: 7, lado: "ct")
	loser_round_cinco = Loser.create(round_id: round_cinco.id, team_id: time_um.id, placar: 6, lado: "t")
	Statistic.create(round_id: round_cinco.id, team_id: time_um.id, user_id: murillo.id, kills: 34, deaths: 8)
	Statistic.create(round_id: round_cinco.id, team_id: time_um.id, user_id: ricardo.id, kills: 7, deaths: 11)
	Statistic.create(round_id: round_cinco.id, team_id: time_dois.id, user_id: edilson.id, kills: 12, deaths: 9)
	Statistic.create(round_id: round_cinco.id, team_id: time_dois.id, user_id: naiara.id, kills: 8, deaths: 7)
	Statistic.create(round_id: round_cinco.id, team_id: time_dois.id, user_id: danilo.id, kills: 5, deaths: 11)
	Statistic.create(round_id: round_cinco.id, team_id: time_dois.id, user_id: wemerson.id, kills: 3, deaths: 11)

	torneio_maio.rounds << round_cinco

	round_sexto = Round.create(tournament_id: torneio_maio.id, map_id: de_aztec.id, ct_team_id: time_dois.id, t_team_id: time_um.id)
	winner_round_sexto = Winner.create(round_id: round_sexto.id, team_id: time_dois.id, placar: 7, lado: "ct")
	loser_round_sexto = Loser.create(round_id: round_sexto.id, team_id: time_um.id, placar: 0, lado: "t")
	Statistic.create(round_id: round_sexto.id, team_id: time_um.id, user_id: murillo.id, kills: 12, deaths: 7)
	Statistic.create(round_id: round_sexto.id, team_id: time_um.id, user_id: ricardo.id, kills: 3, deaths: 7)
	Statistic.create(round_id: round_sexto.id, team_id: time_dois.id, user_id: naiara.id, kills: 10, deaths: 4)
	Statistic.create(round_id: round_sexto.id, team_id: time_dois.id, user_id: danilo.id, kills: 8, deaths: 3)
	Statistic.create(round_id: round_sexto.id, team_id: time_dois.id, user_id: edilson.id, kills: 7, deaths: 3)
	Statistic.create(round_id: round_sexto.id, team_id: time_dois.id, user_id: wemerson.id, kills: 1, deaths: 5)

	torneio_maio.rounds << round_sexto

	round_sete = Round.create(tournament_id: torneio_maio.id, map_id: de_aztec.id, ct_team_id: time_dois.id, t_team_id: time_um.id)
	winner_round_sete = Winner.create(round_id: round_sete.id, team_id: time_dois.id, placar: 7, lado: "ct")
	loser_round_sete = Loser.create(round_id: round_sete.id, team_id: time_um.id, placar: 5, lado: "t")
	Statistic.create(round_id: round_sete.id, team_id: time_um.id, user_id: murillo.id, kills: 20, deaths: 7)
	Statistic.create(round_id: round_sete.id, team_id: time_um.id, user_id: ricardo.id, kills: 7, deaths: 10)
	Statistic.create(round_id: round_sete.id, team_id: time_dois.id, user_id: naiara.id, kills: 7, deaths: 6)
	Statistic.create(round_id: round_sete.id, team_id: time_dois.id, user_id: danilo.id, kills: 7, deaths: 8)
	Statistic.create(round_id: round_sete.id, team_id: time_dois.id, user_id: wemerson.id, kills: 4, deaths: 7)
	Statistic.create(round_id: round_sete.id, team_id: time_dois.id, user_id: edilson.id, kills: 2, deaths: 6)

	torneio_maio.rounds << round_sete

	round_oito = Round.create(tournament_id: torneio_maio.id, map_id: de_cpl_strike.id, ct_team_id: time_um.id, t_team_id: time_dois.id)
	winner_round_oito = Winner.create(round_id: round_oito.id, team_id: time_dois.id, placar: 7, lado: "t")
	loser_round_oito = Loser.create(round_id: round_oito.id, team_id: time_um.id, placar: 0, lado: "ct")
	Statistic.create(round_id: round_oito.id, team_id: time_um.id, user_id: murillo.id, kills: 5, deaths: 7)
	Statistic.create(round_id: round_oito.id, team_id: time_um.id, user_id: ricardo.id, kills: 3, deaths: 7)
	Statistic.create(round_id: round_oito.id, team_id: time_dois.id, user_id: edilson.id, kills: 7, deaths: 1)
	Statistic.create(round_id: round_oito.id, team_id: time_dois.id, user_id: naiara.id, kills: 3, deaths: 3)
	Statistic.create(round_id: round_oito.id, team_id: time_dois.id, user_id: wemerson.id, kills: 2, deaths: 2)
	Statistic.create(round_id: round_oito.id, team_id: time_dois.id, user_id: danilo.id, kills: 2, deaths: 2)

	torneio_maio.rounds << round_oito

	round_nove = Round.create(tournament_id: torneio_maio.id, map_id: de_outlaws.id, ct_team_id: time_dois.id, t_team_id: time_um.id)
	winner_round_nove = Winner.create(round_id: round_nove.id, team_id: time_um.id, placar: 7, lado: "t")
	loser_round_nove = Loser.create(round_id: round_nove.id, team_id: time_dois.id, placar: 3, lado: "ct")
	Statistic.create(round_id: round_nove.id, team_id: time_um.id, user_id: murillo.id, kills: 30, deaths: 3)
	Statistic.create(round_id: round_nove.id, team_id: time_um.id, user_id: ricardo.id, kills: 3, deaths: 6)
	Statistic.create(round_id: round_nove.id, team_id: time_dois.id, user_id: naiara.id, kills: 6, deaths: 8)
	Statistic.create(round_id: round_nove.id, team_id: time_dois.id, user_id: edilson.id, kills: 6, deaths: 8)
	Statistic.create(round_id: round_nove.id, team_id: time_dois.id, user_id: wemerson.id, kills: 0, deaths: 7)
	Statistic.create(round_id: round_nove.id, team_id: time_dois.id, user_id: danilo.id, kills: 0, deaths: 10)

	torneio_maio.rounds << round_nove

	round_dez = Round.create(tournament_id: torneio_maio.id, map_id: de_roma_aimstyle.id, ct_team_id: time_um.id, t_team_id: time_dois.id)
	winner_round_dez = Winner.create(round_id: round_dez.id, team_id: time_um.id, placar: 7, lado: "ct")
	loser_round_dez = Loser.create(round_id: round_dez.id, team_id: time_dois.id, placar: 3, lado: "t")
	Statistic.create(round_id: round_dez.id, team_id: time_um.id, user_id: murillo.id, kills: 41, deaths: 4)
	Statistic.create(round_id: round_dez.id, team_id: time_um.id, user_id: ricardo.id, kills: 8, deaths: 8)
	Statistic.create(round_id: round_dez.id, team_id: time_dois.id, user_id: danilo.id, kills: 5, deaths: 9)
	Statistic.create(round_id: round_dez.id, team_id: time_dois.id, user_id: naiara.id, kills: 4, deaths: 8)
	Statistic.create(round_id: round_dez.id, team_id: time_dois.id, user_id: wemerson.id, kills: 3, deaths: 8)
	Statistic.create(round_id: round_dez.id, team_id: time_dois.id, user_id: edilson.id, kills: 3, deaths: 9)

	torneio_maio.rounds << round_dez

	round_onze = Round.create(tournament_id: torneio_maio.id, map_id: de_villa.id, ct_team_id: time_dois.id, t_team_id: time_um.id)
	winner_round_onze = Winner.create(round_id: round_onze.id, team_id: time_um.id, placar: 7, lado: "t")
	loser_round_onze = Loser.create(round_id: round_onze.id, team_id: time_dois.id, placar: 5, lado: "ct")
	Statistic.create(round_id: round_onze.id, team_id: time_um.id, user_id: murillo.id, kills: 26, deaths: 6)
	Statistic.create(round_id: round_onze.id, team_id: time_um.id, user_id: ricardo.id, kills: 11, deaths: 9)
	Statistic.create(round_id: round_onze.id, team_id: time_dois.id, user_id: edilson.id, kills: 6, deaths: 6)
	Statistic.create(round_id: round_onze.id, team_id: time_dois.id, user_id: naiara.id, kills: 6, deaths: 9)
	Statistic.create(round_id: round_onze.id, team_id: time_dois.id, user_id: wemerson.id, kills: 5, deaths: 10)
	Statistic.create(round_id: round_onze.id, team_id: time_dois.id, user_id: danilo.id, kills: 3, deaths: 9)

	torneio_maio.rounds << round_onze

	round_doze = Round.create(tournament_id: torneio_maio.id, map_id: de_winter_village.id, ct_team_id: time_um.id, t_team_id: time_dois.id)
	winner_round_doze = Winner.create(round_id: round_doze.id, team_id: time_dois.id, placar: 7, lado: "t")
	loser_round_doze = Loser.create(round_id: round_doze.id, team_id: time_um.id, placar: 5, lado: "ct")
	Statistic.create(round_id: round_doze.id, team_id: time_um.id, user_id: murillo.id, kills: 25, deaths: 9)
	Statistic.create(round_id: round_doze.id, team_id: time_um.id, user_id: ricardo.id, kills: 12, deaths: 10)
	Statistic.create(round_id: round_doze.id, team_id: time_dois.id, user_id: naiara.id, kills: 6, deaths: 7)
	Statistic.create(round_id: round_doze.id, team_id: time_dois.id, user_id: edilson.id, kills: 6, deaths: 8)
	Statistic.create(round_id: round_doze.id, team_id: time_dois.id, user_id: danilo.id, kills: 5, deaths: 9)
	Statistic.create(round_id: round_doze.id, team_id: time_dois.id, user_id: wemerson.id, kills: 2, deaths: 10)

	torneio_maio.rounds << round_doze

	###############################

end

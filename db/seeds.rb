# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ActiveRecord::Base.transaction do

	murillo = User.create(nome: "Murillo Parreira", email: "murparreira@gmail.com", steamid: "", login: "admin", password: "admin", admin: true, ativo: true)
	ricardo = User.create(nome: "Ricardo Pulice", email: "rpulice@gmail.com", steamid: "", login: "rpulice", password: "rpulice", ativo: true)

	edilson = User.create(nome: "Edilson Borges", email: "edilsonfb@gmail.com", steamid: "", login: "edilsonfb", password: "edilsonfb", ativo: true)
	danilo = User.create(nome: "Danilo Lopes", email: "dalinolopesdemoraes@gmail.com", steamid: "", login: "bileite", password: "bileite", ativo: true)
	wemerson = User.create(nome: "Wemerson Souto", email: "wemerson.souto@gmail.com", steamid: "", login: "amigao", password: "amigao", ativo: true)
	naiara = User.create(nome: "Naiara Fatima", email: "nnaiara7@gmail.com", steamid: "", login: "naiara", password: "naiara", ativo: true)

	aztec = Map.create(nome: "Aztec", sigla: "de_aztec")
	desertim = Map.create(nome: "Desertim", sigla: "de_desertcity_fixed")
	asia = Map.create(nome: "Asia", sigla: "de_asia")

	torneio = Tournament.create(nome: "Torneio de Maio")

	time_um = Team.create(nome: "Joalheria")
	time_um.users << murillo
	time_um.users << ricardo

	time_dois = Team.create(nome: "Ladrões")
	time_dois.users << edilson
	time_dois.users << danilo
	time_dois.users << wemerson
	time_dois.users << naiara

	torneio.teams << time_um
	torneio.teams << time_dois

	round_um = Round.create(tournament_id: torneio.id, map_id: aztec.id)
	winner_round_um = Winner.create(round_id: round_um.id, team_id: time_um.id, placar: 7, lado: "ct")
	loser_round_um = Loser.create(round_id: round_um.id, team_id: time_dois.id, placar: 4, lado: "t")
	Statistic.create(round_id: round_um.id, team_id: time_um.id, user_id: murillo.id, kills: 35, deaths: 7)
	Statistic.create(round_id: round_um.id, team_id: time_um.id, user_id: ricardo.id, kills: 8, deaths: 15)
	Statistic.create(round_id: round_um.id, team_id: time_dois.id, user_id: edilson.id, kills: 4, deaths: 15)
	Statistic.create(round_id: round_um.id, team_id: time_dois.id, user_id: danilo.id, kills: 7, deaths: 17)
	Statistic.create(round_id: round_um.id, team_id: time_dois.id, user_id: wemerson.id, kills: 2, deaths: 18)
	Statistic.create(round_id: round_um.id, team_id: time_dois.id, user_id: naiara.id, kills: 10, deaths: 13)

	torneio.rounds << round_um

	round_dois = Round.create(tournament_id: torneio.id, map_id: aztec.id)
	winner_round_dois = Winner.create(round_id: round_dois.id, team_id: time_dois.id, placar: 7, lado: "ct")
	loser_round_dois = Loser.create(round_id: round_dois.id, team_id: time_um.id, placar: 1, lado: "t")
	Statistic.create(round_id: round_dois.id, team_id: time_um.id, user_id: murillo.id, kills: 22, deaths: 10)
	Statistic.create(round_id: round_dois.id, team_id: time_um.id, user_id: ricardo.id, kills: 3, deaths: 8)
	Statistic.create(round_id: round_dois.id, team_id: time_dois.id, user_id: edilson.id, kills: 8, deaths: 10)
	Statistic.create(round_id: round_dois.id, team_id: time_dois.id, user_id: danilo.id, kills: 8, deaths: 12)

	torneio.rounds << round_dois
	
end
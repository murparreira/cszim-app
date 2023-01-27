# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ActiveRecord::Base.transaction do

  Game.destroy_all
  ServerConfiguration.destroy_all
  Season.destroy_all
  User.destroy_all
  Map.destroy_all
  Rankme.destroy_all
  Tournament.destroy_all
  Team.destroy_all

  game = Game.create(
    nome: 'Counter Strike: Global Offensive',
    ativo: true,
    sigla: 'CSGO'
  )

  ServerConfiguration.create(
    nome: 'Default',
    numero_partidas: 10,
    server_name_or_ip: ENV['SERVER_NAME_OR_IP'],
    server_port: ENV['SERVER_PORT'],
    server_user: ENV['SERVER_USER'],
    server_password: ENV['SERVER_PORT'],
    ativo: true
  )

  Season.create(
    nome: 'Temporada 1',
    ativo: true
  )

  User.create(
    nome: 'System Admin',
    login: 'admin',
    password: 'admin',
    email: 'sysadmin@gmail.com',
    admin: true,
    steamid: '',
    steam: ''
  )

  User.create(
    nome: 'Murillo',
    login: 'murparreira@gmail.com',
    password: 'admin',
    email: 'murparreira@gmail.com',
    admin: true,
    steamid: 'murifoxx',
    steam: 'STEAM_0:1:204322906'
  )

  User.create(
    nome: 'Nikael',
    login: 'nikael@gmail.com',
    password: 'admin',
    email: 'nikael@gmail.com',
    admin: false,
    steamid: '76561198382208296',
    steam: 'STEAM_0:0:210971284'
  )

  User.create(
    nome: 'Ismael',
    login: 'ismael@gmail.com',
    password: 'admin',
    email: 'ismael@gmail.com',
    admin: false,
    steamid: '76561198115661275',
    steam: 'STEAM_0:1:77697773'
  )

  User.create(
    nome: 'Yure',
    login: 'yure@gmail.com',
    password: 'admin',
    email: 'yure@gmail.com',
    admin: false,
    steamid: 'yurenery',
    steam: 'STEAM_0:0:59688084'
  )

  User.create(
    nome: 'Victor',
    login: 'victor@gmail.com',
    password: 'admin',
    email: 'victor@gmail.com',
    admin: false,
    steamid: 'znexy',
    steam: 'STEAM_0:1:75095884'
  )

  User.create(
    nome: 'Naiara',
    login: 'naiara@gmail.com',
    password: 'admin',
    email: 'naiara@gmail.com',
    admin: false,
    steamid: '76561198158451974',
    steam: 'STEAM_0:0:99093123'
  )

  User.create(
    nome: 'Allan',
    login: 'allan@gmail.com',
    password: 'admin',
    email: 'allan@gmail.com',
    admin: false,
    steamid: 'allanmenesesec',
    steam: 'STEAM_0:1:59095083'
  )

  User.create(
    nome: 'João Victor',
    login: 'joaovictor@gmail.com',
    password: 'admin',
    email: 'joaovictor@gmail.com',
    admin: false,
    steamid: '76561198121539961',
    steam: 'STEAM_0:1:80637116'
  )

  User.create(
    nome: 'Franz',
    login: 'franz@gmail.com',
    password: 'admin',
    email: 'franz@gmail.com',
    admin: false,
    steamid: 'strund3r',
    steam: 'STEAM_0:0:33357487'
  )

  User.create(
    nome: 'Ricardo Barbosa',
    login: 'rick@gmail.com',
    password: 'admin',
    email: 'rick@gmail.com',
    admin: false,
    steamid: '76561198076270581',
    steam: 'STEAM_0:1:58002426'
  )

  User.create(
    nome: 'Ricardo Pulice',
    login: 'ricardopulice@gmail.com',
    password: 'admin',
    email: 'ricardopulice@gmail.com',
    admin: false,
    steamid: '76561198250892958',
    steam: 'STEAM_0:0:145313615'
  )

  User.create(
    nome: 'Michael',
    login: 'maicouel@gmail.com',
    password: 'admin',
    email: 'maicouel@gmail.com',
    admin: false,
    steamid: 'maicouel',
    steam: 'STEAM_0:1:43147058'
  )

  User.create(
    nome: 'Renan',
    login: 'lastzfighter@gmail.com',
    password: 'admin',
    email: 'lastzfighter@gmail.com',
    admin: false,
    steamid: 'lastzfighter',
    steam: 'STEAM_0:1:41454614'
  )

  User.create(
    nome: 'Eduardo Lucena',
    login: 'dudsz@gmail.com',
    password: 'admin',
    email: 'dudsz@gmail.com',
    admin: false,
    steamid: '76561198112143102',
    steam: 'STEAM_0:0:75938687'
  )

  User.create(
    nome: 'Edilson',
    login: 'edilsonfb@gmail.com',
    password: 'admin',
    email: 'edilsonfb@gmail.com',
    admin: false,
    steamid: 'edilson',
    steam: 'STEAM_0:1:42926840'
  )

  User.create(
    nome: 'Eduardo Tavares',
    login: 'eduardotv@gmail.com',
    password: 'admin',
    email: 'eduardotv@gmail.com',
    admin: false,
    steamid: 'dot22',
    steam: 'STEAM_0:1:35250772'
  )

  User.create(
    nome: 'Ramon',
    login: 'ramonvs@gmail.com',
    password: 'admin',
    email: 'ramonvs@gmail.com',
    admin: false,
    steamid: 'ramonvs',
    steam: 'STEAM_0:1:79524414'
  )

  User.create(
    nome: 'Lucas Pacífico',
    login: 'lupoc@gmail.com',
    password: 'admin',
    email: 'lupoc@gmail.com',
    admin: false,
    steamid: '76561198116367387',
    steam: 'STEAM_0:1:78050829'
  )

  Map.create(
    nome: 'Ancient',
    sigla: 'de_ancient',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_ancient.jpg')
  )

  Map.create(
    nome: 'Anubis',
    sigla: 'de_anubis',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_anubis.jpg')
  )

  Map.create(
    nome: 'Inferno',
    sigla: 'de_inferno',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_inferno.jpg')
  )

  Map.create(
    nome: 'Mirage',
    sigla: 'de_mirage',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_mirage.jpg')
  )

  Map.create(
    nome: 'Nuke',
    sigla: 'de_nuke',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_nuke.jpg')
  )

  Map.create(
    nome: 'Overpass',
    sigla: 'de_overpass',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_overpass.jpg')
  )

  Map.create(
    nome: 'Vertigo',
    sigla: 'de_vertigo',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_vertigo.jpg')
  )

  Map.create(
    nome: 'Cache',
    sigla: 'de_cache',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_cache.jpg')
  )

  Map.create(
    nome: 'Dust II',
    sigla: 'de_dust2',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_dust2.jpg')
  )

  Map.create(
    nome: 'Train',
    sigla: 'de_train',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_train.jpg')
  )

  Map.create(
    nome: 'Train',
    sigla: 'de_train',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_train.jpg')
  )

  Map.create(
    nome: 'Canals',
    sigla: 'de_canals',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_canals.jpg')
  )

  Map.create(
    nome: 'Cobblestone',
    sigla: 'de_cbble',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_cbble.jpg')
  )

  Map.create(
    nome: 'Austria',
    sigla: 'de_austria',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_austria.jpg')
  )

  Map.create(
    nome: 'Abbey',
    sigla: 'de_abbey',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_abbey.jpg')
  )

  Map.create(
    nome: 'Biome',
    sigla: 'de_biome',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_biome.jpg')
  )

  Map.create(
    nome: 'Chlorine',
    sigla: 'de_chlorine',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_chlorine.jpg')
  )

  Map.create(
    nome: 'Mutiny',
    sigla: 'de_mutiny',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_mutiny.jpg')
  )

  Map.create(
    nome: 'Mocha',
    sigla: 'de_mocha',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_mocha.jpg')
  )

  Map.create(
    nome: 'Grind',
    sigla: 'de_grind',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_grind.jpg')
  )

  Map.create(
    nome: 'Engage',
    sigla: 'de_engage',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_engage.jpg')
  )

  Map.create(
    nome: 'Seaside',
    sigla: 'de_seaside',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_seaside.jpg')
  )

  Map.create(
    nome: 'St. Marc',
    sigla: 'de_stmarc',
    ativo: true,
    game_id: game.id,
    imagem: File.new(Rails.root + 'app/assets/images/de_stmarc.jpg')
  )
  
end

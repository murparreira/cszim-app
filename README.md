# README

### CSZIM-APP ###

* Projeto Rails para apoio aos campeonatos de CS
* 2.1-alpha

### Como instalar e rodar? ###

* Tenha o **docker** e o **docker-compose** instalado na sua máquina.
* Use **docker-compose build** para buildar a imagem
* Use **docker-compose up** para subir o container
* Crie um arquivo **.env** na raiz do projeto com o seguinte conteúdo
    ````
    ## Configurações da máquina onde o servidor está rodando ##
    SERVER_NAME_OR_IP=
    SERVER_PORT=
    SERVER_USER=
    SERVER_PASSWORD=
    ## Configurações do PostgreSQL ##
    POSTGRESQL_NAME=
    POSTGRESQL_USER=
    POSTGRESQL_PASSWORD=
    POSTGRESQL_HOST=
    ## Se estiver usando o manager v1, configurações do MySQL do Rankme ##
    MYSQL_DATABASE=
    MYSQL_USER=
    MYSQL_PASSWORD=
    MYSQL_PORT=
    ## URL do servidor de parsing das demos ##
    PARSE_URL=
    ````
* Use **docker-compose run --rm web rake db:create** para criar o BD
* Use **docker-compose run --rm web rake db:migrate** para rodar as migrations
* Use **docker-compose run --rm web rake db:seed** para popular o BD com algumas configurações iniciais
* Logue com o seu usuário (Informações dos usuários podem ser vistas no arquivo db/seeds.rb)
* Fork o projeto e clone para uma pasta no sistema:
* Navegue para a pasta do projeto:

### Como contribuir? ###

### 1. Fork no projeto e clone o seu fork:

    git clone git@github.com:YOUR-USERNAME/YOUR-FORKED-REPO.git

### 2. Adicione o projeto principal como remote para o seu fork 

    cd seu/repositorio/clonado
    git remote add upstream https://github.com/murparreira/cszim-app.git
    git fetch upstream

### 3. Atualize sempre o seu fork com o código original para evitar conflitos e ter sempre as atualizações:

    git pull upstream master

### 4. Ao terminar as modificaçes, abra um pull request para incorporar o seu código no repositório principal.

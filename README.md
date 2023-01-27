# README

### CSZIM-APP ###

* Projeto Rails para apoio aos campeonatos de CS
* 2.0-alpha

### Como instalar e rodar? ###

* Tenha o **docker** e o **docker-compose** instalado na sua máquina.
* Use **docker-compose build** para buildar a imagem
* Use **docker-compose up** para subir o container
* Use **docker-compose run web rake db:migrate** para rodar as migrations no BD se o build não o fez
* Crie um arquivo **.env** na raiz do projeto com o seguinte conteúdo
    ````
    SERVER_NAME_OR_IP=
    SERVER_PORT=
    SERVER_USER=
    SERVER_PASSWORD=
    ````
* Use **docker-compose run web rake db:seed** para criar os dados iniciais
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

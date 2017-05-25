# README

### CSZIM-APP ###

* Projeto Rails para apoio aos campeonatos de CS
* 1.0-alpha

### Como instalar e rodar? ###

* Instalação do ambiente:
    * **sudo apt-get install curl build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev libgmp-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion libpq-dev**
    * **gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3**
    * **curl -L https://get.rvm.io | bash -s stable**
    * **rvm install 2.4.0 # Ou uma versão mais recente se existir**
    * **gem install bundler**
* Fork o projeto e clone para uma pasta no sistema:
* Navegue para a pasta do projeto:
* Instale todas as dependências (Seguindo o primeiro passo, vc terá o bundler instalado):
    * **bundle install**
* Crie o banco de dados, as tabelas e o popule com dados fictícios:
    * **rake db:drop && rake db:create && rake db:migrate && rake db:seed**
* Inicie o servidor e veja se está tudo funcionando corretamente: **rails s**
* Logue com o seu usuário (Informações dos usuários podem ser vistas no arquivo db/seeds.rb)

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

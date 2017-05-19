# README

### CSZIM-APP ###

* Projeto Rails para apoio aos campeonatos de CS
* 1.0-alpha

### Como instalar e rodar? ###

* Siga os passos para instalação do ambiente em:
    * http://www.akitaonrails.com/2015/01/28/ruby-e-rails-no-ubuntu-14-04-lts-trusty-tahr
* Fork o projeto e clone para uma pasta no sistema:
* Navegue para a pasta do projeto:
* Instale todas as dependências (Seguindo o primeiro passo, vc terá o bundler instalado):
    * **bundle install**
* Crie o banco de dados, as tabelas e o popule com dados fictícios:
    * **rake db:drop && rake db:create && rake db:migrate && rake db:seed**
* Inicie o servidor e veja se está tudo funcionando corretamente: **rails s**
* Logue com o seu usuário (Informações dos usuários podem ser vistas no arquivo db/seeds.rb):  
    * login: admin
    * senha: admin

class RankmeRecord < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :development_csgo
end

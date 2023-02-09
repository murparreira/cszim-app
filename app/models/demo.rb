class Demo < ApplicationRecord

  has_many :player_statistics
  has_many :demo_rounds
  belongs_to :map
  belongs_to :time_vencedor, class_name: 'Team'
  belongs_to :time_perdedor, class_name: 'Team'

  def ct_wins
    demo_rounds.where(winningSide: 'CT').count
  end

  def t_wins
    demo_rounds.where(winningSide: 'T').count
  end

end

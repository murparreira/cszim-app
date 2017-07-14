class Chart
  def self.chart(data)
    nome = []
    kill = []
    death = []
    pie_kill = []
    pie_death = []
    data.each do |statistic|
      user = User.find(statistic.user_id)
      ratio = statistic.ratio
      media = (statistic.kills.to_f+statistic.deaths.to_f)/2
      nome << user.nome + '<br>' + ratio.to_s
      kill << statistic.kills
      death << statistic.deaths
      pie_kill << {name: user.nome.to_s, y: statistic.kills}
      pie_death << {name: user.nome.to_s, y: statistic.deaths}
    end
    line_kill = (data.map {|k| k['kills']}.reduce(0, :+))/data.size
    line_death = (data.map {|d| d['deaths']}.reduce(0, :+))/data.size
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Kikiu")
      f.xAxis(categories: nome)
      f.labels(items: [{html: 'Kills', style: {left: '180px', top: '2px', color: 'black'}},{html: 'Deaths', style: {left: '380px', top: '2px', color: 'black'}}])
      f.series(type: 'column', name: "Kills", data: kill, color: '#23d160')
      f.series(type: 'column', name: "Deaths", data: death, color: '#ff3860')
      f.series(type: 'pie', name: 'Kill', data: pie_kill, center: [250, 20], size: 100, showInLegend: false, dataLabels: {enabled: false,},
          tooltip: {pointFormat: '{series.name}: {point.y} - <b>{point.percentage:.1f}%</b>'})
      f.series(type: 'pie', name: 'Death', data: pie_death, center: [450, 20], size: 100, showInLegend: false, dataLabels: {enabled: false},
          tooltip: {pointFormat: '{series.name}: {point.y} - <b>{point.percentage:.1f}%</b>'})
      f.yAxis [
        {plotLines: [{color: '#ff3860', value: line_death, width: 2},
                    {color: '#23d160', value: line_kill, width: 2}]}
      ]
      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
    end
  end

  def self.line_chart
    LazyHighCharts::HighChart.new('line') do |f|
      f.title(text: "Últimos 5 torneios")
      f.yAxis(title: "Kills", categories: [])
      tournaments = Tournament.order(id: :desc).limit(5).reverse
      User.order(id: :asc).each do |user|
        data = []
        n_kills = 0
        tournaments.each do |tournament|
          statistic = Statistic.joins(round: :tournament).select("SUM(kills) AS kills").where("user_id = ? AND tournaments.id = ?", user.id, tournament.id).first
          kills = statistic.kills || 0
          n_kills += kills
          data << n_kills
        end
        f.series(name: user.nome, data: data)
      end
      categories = []
      tournaments.each do |tournament|
        categories << tournament.nome
      end
      f.xAxis(categories: categories)
      f.legend(align: 'right', verticalAlign: 'top', layout: 'vertical')
    end
  end

  def self.historic_chart(user_id)
    LazyHighCharts::HighChart.new('column') do |f|
      f.title(text: "Histórico de Ratio (Kills/Deaths)")
      f.yAxis(title: "Ratio", categories: [])
      data = []
      result = ActiveRecord::Base.connection.execute "SELECT CAST(SUM(kills) AS float)/CAST(SUM(deaths) AS float) AS ratio, tournament_id FROM statistics s INNER JOIN rounds r ON s.round_id = r.id INNER JOIN tournaments t ON r.tournament_id = t.id WHERE map_id IS NOT NULL AND user_id = #{user_id} GROUP BY tournament_id ORDER BY tournament_id ASC"
      result.each do |hash|
        data << hash["ratio"]
      end
      f.series(name: "Ratio", data: data)
      categories = []
      Tournament.order(id: :asc).each do |tournament|
        categories << tournament.nome
      end
      f.xAxis(categories: categories)
      f.legend(align: 'right', verticalAlign: 'top', layout: 'vertical')
    end
  end

end

=begin
ActiveRecord::Base.connection.execute "SELECT CAST(SUM(kills) AS float)/CAST(SUM(deaths) AS float) AS ratio, map_id FROM statistics s INNER JOIN rounds r ON s.round_id = r.id WHERE map_id IS NOT NULL AND user_id = 1 GROUP BY map_id ORDER BY ratio"
ActiveRecord::Base.connection.execute "SELECT CAST(SUM(kills) AS float)/CAST(SUM(deaths) AS float) AS ratio, tournament_id FROM statistics s INNER JOIN rounds r ON s.round_id = r.id INNER JOIN tournaments t ON r.tournament_id = t.id WHERE map_id IS NOT NULL AND user_id = 1 GROUP BY tournament_id ORDER BY ratio"
=end

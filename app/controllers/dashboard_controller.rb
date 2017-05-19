class DashboardController < ApplicationController
  before_action :authenticate_user

  def index
  	@dataGeral = Statistic.select("SUM(kills) AS kills, SUM(deaths) AS deaths, user_id").group(:user_id).order("kills DESC")
  	nome = Array.new
    kill = Array.new
    death = Array.new
    line = Array.new
    pieKill = Array.new
    pieDeath = Array.new
		@dataGeral.each do |statistic|
			user = User.find(statistic.user_id)
			ratio = (statistic.kills.to_f/statistic.deaths.to_f).round(2)
			media = (statistic.kills.to_f+statistic.deaths.to_f)/2
			nome << user.nome + '<br>' + ratio.to_s
			kill << statistic.kills
			death << statistic.deaths
			line << media
			pieKill << {name: user.nome.to_s, y: statistic.kills}
			pieDeath << {name: user.nome.to_s, y: statistic.deaths}
		end
    @chartGeral = LazyHighCharts::HighChart.new('graph') do |f|
    	f.title(text: "Kikiu")
			f.xAxis(categories: nome)
			f.labels(items: [{html: 'Kills', style: {left: '180px', top: '2px', color: 'black'}},{html: 'Deaths', style: {left: '380px', top: '2px', color: 'black'}}])
			f.series(type: 'column', name: "Kills", data: kill, color: '#23d160')
			f.series(type: 'column', name: "Deaths", data: death, color: '#ff3860')
			f.series(type: 'spline', name: "Média", data: line, lineColor: "#3273dc", marker: {lineWidth: 2, fillColor: "#000"})
			f.series(type: 'pie', name: 'Kill', data: pieKill, center: [250, 20], size: 100, showInLegend: false, dataLabels: {enabled: false,}, 
					tooltip: {pointFormat: '{series.name}: {point.y} - <b>{point.percentage:.1f}%</b>'})
			f.series(type: 'pie', name: 'Death', data: pieDeath, center: [450, 20], size: 100, showInLegend: false, dataLabels: {enabled: false}, 
					tooltip: {pointFormat: '{series.name}: {point.y} - <b>{point.percentage:.1f}%</b>'})
			f.yAxis [
			  {title: {text: "Kills", margin: 70} },
			  {title: {text: "Deaths"}, opposite: true},
			]
			f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
		end
  end

end
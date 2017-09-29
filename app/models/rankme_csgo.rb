class RankmeCsgo < ApplicationRecord
	belongs_to :tournament
	belongs_to :user
	belongs_to :round
	belongs_to :season
	belongs_to :team

	def ratio
		(kills.to_f/deaths.to_f).round(2)
	end

	def knife_percentage
		((knife.to_f/kills.to_f)*100).round(2)
	end

	def glock_percentage
		((glock.to_f/kills.to_f)*100).round(2)
	end

	def usp_percentage
		((usp.to_f/kills.to_f)*100).round(2)
	end

	def p228_percentage
		((p228.to_f/kills.to_f)*100).round(2)
	end

	def deagle_percentage
		((deagle.to_f/kills.to_f)*100).round(2)
	end

	def elite_percentage
		((elite.to_f/kills.to_f)*100).round(2)
	end

	def fiveseven_percentage
		((fiveseven.to_f/kills.to_f)*100).round(2)
	end

	def m3_percentage
		((m3.to_f/kills.to_f)*100).round(2)
	end

	def xm1014_percentage
		((xm1014.to_f/kills.to_f)*100).round(2)
	end

	def mac10_percentage
		((mac10.to_f/kills.to_f)*100).round(2)
	end

	def tmp_percentage
		((tmp.to_f/kills.to_f)*100).round(2)
	end

	def mp5navy_percentage
		((mp5navy.to_f/kills.to_f)*100).round(2)
	end

	def ump45_percentage
		((ump45.to_f/kills.to_f)*100).round(2)
	end

	def p90_percentage
		((p90.to_f/kills.to_f)*100).round(2)
	end

	def galil_percentage
		((galil.to_f/kills.to_f)*100).round(2)
	end

	def ak47_percentage
		((ak47.to_f/kills.to_f)*100).round(2)
	end

	def sg550_percentage
		((sg550.to_f/kills.to_f)*100).round(2)
	end

	def famas_percentage
		((famas.to_f/kills.to_f)*100).round(2)
	end

	def m4a1_percentage
		((m4a1.to_f/kills.to_f)*100).round(2)
	end

	def aug_percentage
		((aug.to_f/kills.to_f)*100).round(2)
	end

	def scout_percentage
		((scout.to_f/kills.to_f)*100).round(2)
	end

	def sg552_percentage
		((sg552.to_f/kills.to_f)*100).round(2)
	end

	def awp_percentage
		((awp.to_f/kills.to_f)*100).round(2)
	end

	def g3sg1_percentage
		((g3sg1.to_f/kills.to_f)*100).round(2)
	end

	def m249_percentage
		((m249.to_f/kills.to_f)*100).round(2)
	end

	def hegrenade_percentage
		((hegrenade.to_f/kills.to_f)*100).round(2)
	end

	def flashbang_percentage
		((flashbang.to_f/kills.to_f)*100).round(2)
	end

	def smokegrenade_percentage
		((smokegrenade.to_f/kills.to_f)*100).round(2)
	end
end

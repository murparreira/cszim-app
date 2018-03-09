class NullRankme
	def initialize(rankme)
		@rankme = rankme
	end

	def method_missing(m, *args, &block)
		if @rankme.nil?
			0
		else
    	@rankme.try(m.to_sym)
		end
  end
end

module Okexfunctions
	def self.create_table(result)
		table = []
			
			cumulative = 0
			result.each do |a|
				price = a[0].to_f
				size = a[1].to_f
				total = (price * size)

				cumulative += total
				table << {price: price, size: size, total: total, cumulative: cumulative}
			end

		return table
	end

	def self.calculate_avg_price(array, money)

		
		
		money = money.to_i
		arr = []	
		flag = 0
		array.each do |a|

			cumulative = a[:cumulative]
			if money < cumulative
				flag = 1
				if arr.length > 0
					last = arr.last[:cumulative]
				else		
					last = 0
				end
				excess = money - last
				price = a[:price]
				size = (excess / price)
				total = (price * size)
				cumulative_n = (last + total)

				arr << {price: price, size: size, total: total, cumulative: cumulative_n}
			elsif money > cumulative
				arr << a
			
				
			end
			if flag == 1
				break;
			end
		end

		(arr.last[:cumulative].to_i == money.to_i) ? status = 'OK' : status = 'Not enough volume'
		amount = (arr.inject(0) {|sum, hash| sum + hash[:size]})
		total_price = arr.inject(0) {|sum, hash| sum + hash[:total]}
		avg_price = (total_price / amount)
		return avg_price.round(2), amount.round(2), status, arr
	end

end
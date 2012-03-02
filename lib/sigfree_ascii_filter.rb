module ASCII
	class String
		def initialize(string)
  		  @input_string = string
		end

		def ascii_int
			ascii_array = Array.new
			@input_string.each_byte{ |c| ascii_array<<c}
			ascii_array
		end

		def ascii_hex
			ascii_array = ascii_int
			ascii_array.collect!{|num| num.to_s(16)}
		end

		def self.ascii_to_string(ascii_array)
			ascii_array.collect!{|num| num.chr}
		end
	end

	class Filter
		def self.filter(ascii_array)
			filtered = Array.new
			ascii_array.collect!{|elem_val| filtered<<elem_val unless elem_val<20||elem_val>126}
			puts "ascii_array:#{filtered}"
			filtered
		end
	end
end


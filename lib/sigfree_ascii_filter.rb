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
	end

	class Filter
		def initialize(hex_set) 
			@hex_set = hex_set
		end
		def filter
			@hex_set.each{|hex_val| @hex_set.delete(hex_val) if hex_val.to_i<20||hex_val.to_i>'7E'.to_i}
			@hex_set
		end
	end
end